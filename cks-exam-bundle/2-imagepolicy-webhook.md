# ImagePolicyWebhook


## 🧩 Problem Statement

<details>
<summary>Click to expand the problem statement</summary>

A Kubernetes cluster built using **kubeadm** must enforce strict container image security controls.

An image scanning service is already running in the cluster and exposes an HTTPS webhook endpoint to validate images before they are allowed to run.

An incomplete admission controller configuration is provided at:

```bash
/etc/kubernetes/webhook/
```

The image scanning webhook is reachable at:

```bash
https://image-policy-webhook.default
```

---

### 🎯 Task

Complete the integration of container image validation by implementing an **ImagePolicyWebhook Validating Admission Controller**.

1. Update the Kubernetes API server configuration so the required admission plugin is enabled and uses the provided AdmissionConfiguration.
2. Configure ImagePolicyWebhook to operate in **fail-closed** mode (reject images if the webhook backend is unavailable).
3. Verify the setup by deploying the test workload:

```bash
~/nginx-deployment.yaml
```

This workload uses an image that should be denied by the policy. You may delete and recreate it as needed.

---

### 📌 Notes

* Apply changes on the **control plane node**.
* Ensure the admission controller is functioning correctly before finishing.

</details>

---

## ✅ Solution

<details>
<summary>Click to expand the solution</summary>

### Step 1: Update ImagePolicyWebhook config (fail-closed)

Go to the webhook config directory (based on your setup):

```
cd /etc/kubernetes/webhook/
```

Edit:

```
sudo vim image-policy-config.yml
```

Change:

**From**

```yaml
defaultAllow: true
```

**To**

```yaml
defaultAllow: false
```

This enables **fail-closed** behavior.

---

### Step 2: Add webhook server details in kubeconfig

Edit:

```
sudo vim kube-config.yml
```

Set the `server:` field to the webhook endpoint:

```yaml
server: https://image-policy-webhook.default
```

✅ Make sure the hostname and port are correct for your environment.

---

### Step 3: Enable ImagePolicyWebhook in kube-apiserver

Edit the kube-apiserver static Pod manifest:

```
sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

Ensure the following flags are present:

```yaml
- --enable-admission-plugins=ImagePolicyWebhook
- --admission-control-config-file=/etc/kubernetes/admission-controllers/admission-config.yaml
```

> Note: Sometimes `--enable-admission-plugins` already exists with multiple plugins.
> If so, **append** `ImagePolicyWebhook` instead of overwriting the list.

---

### Step 4: Restart kubelet (apiserver restarts automatically)

```
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

---

### Step 5: Test by deploying the workload

```
kubectl apply -f ~/nginx-deployment.yaml
```

If configured correctly, the Pod should be denied and not created.

Check resources:

```
kubectl get deploy,rs,pods
```

Describe the ReplicaSet to confirm webhook denial:

```
kubectl describe rs <rs-name>
```

Expected event example:

```
Warning  FailedCreate  ...  replicaset-controller  Error creating: pods "nginx-..." is forbidden:
image policy webhook backend denied one or more images: denied: image tag is missing (implicit latest is not allowed)
```

</details>

---

## 🛠 Setup Practice Scenario

<details>
<summary>Click to expand setup steps</summary>

### 1) Install cfssl (for cert generation)

```
sudo apt install -y golang-cfssl
```

---

### 2) Generate server key + CSR

```
cat <<EOF | cfssl genkey - | cfssljson -bare server
{
  "hosts": [
    "image-policy-webhook",
    "image-policy-webhook.default",
    "image-policy-webhook.default.svc",
    "image-policy-webhook.default.svc.cluster.local",
    "10.96.0.10",
    "10.0.1.205",
    "10.32.0.1"
  ],
  "CN": "system:node:image-policy-webhook.default.pod.cluster.local",
  "key": {
    "algo": "ecdsa",
    "size": 256
  },
  "names": [
    {
      "O": "system:nodes"
    }
  ]
}
EOF
```

---

### 3) Create CSR in Kubernetes and approve

```
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: image-policy-webhook
spec:
  request: $(cat server.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kubelet-serving
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF
```

```
kubectl certificate approve image-policy-webhook
```

```
kubectl get csr image-policy-webhook -o jsonpath='{.status.certificate}' | base64 --decode > tls.crt
```

Copy the key:

```
cp server-key.pem tls.key
```

---

### 4) Create TLS Secret for the webhook

```
kubectl -n default create secret tls image-policy-webhook-tls \
  --cert=tls.crt \
  --key=tls.key
```

---

### 5) Deploy the webhook server (Deployment + Service)

```
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: image-policy-webhook
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: image-policy-webhook
  template:
    metadata:
      labels:
        app: image-policy-webhook
    spec:
      tolerations:
      - key: node-role.kubernetes.io/control-plane
        operator: Exists
        effect: NoSchedule
      containers:
      - name: webhook
        image: devopstechtales/cks-exam-questions:image-policy-webhook-v1
        ports:
        - containerPort: 443
        volumeMounts:
        - name: tls
          mountPath: /tls
          readOnly: true
      volumes:
      - name: tls
        secret:
          secretName: image-policy-webhook-tls
---
apiVersion: v1
kind: Service
metadata:
  name: image-policy-webhook
  namespace: default
spec:
  type: NodePort
  selector:
    app: image-policy-webhook
  ports:
  - name: https
    port: 443
    targetPort: 443
    nodePort: 32000
    protocol: TCP
EOF
```

---

### 6) Create admission config files

```
sudo mkdir -p /etc/kubernetes/webhook
sudo cp tls.crt /etc/kubernetes/webhook/tls.crt
```

AdmissionConfiguration file:

```
sudo tee /etc/kubernetes/webhook/admission-config.yml >/dev/null <<'EOF'
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  path: image-policy-config.yml
EOF
```

ImagePolicy config (fail-open by default here; you will flip it in the solution):

```
sudo tee /etc/kubernetes/webhook/image-policy-config.yml >/dev/null <<'EOF'
imagePolicy:
  kubeConfigFile: /etc/kubernetes/webhook/kube-config.yml
  allowTTL: 50
  denyTTL: 50
  retryBackoff: 500
  defaultAllow: true
EOF
```

Kubeconfig for API server → webhook:

```
sudo tee /etc/kubernetes/webhook/kube-config.yml >/dev/null <<'EOF'
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /etc/kubernetes/webhook/tls.crt
    server: 
  name: image-policy-webhook
contexts:
- context:
    cluster: image-policy-webhook
    user: api-server
  name: image-policy-webhook
current-context: image-policy-webhook
users:
- name: api-server
  user:
    client-certificate: /etc/kubernetes/pki/apiserver.crt
    client-key: /etc/kubernetes/pki/apiserver.key
EOF
```

---

### 7) Update kube-apiserver to mount webhook config

Edit:

```
sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

Add this flag:

```yaml
- --admission-control-config-file=/etc/kubernetes/webhook/admission-config.yml
```

Add volume + mount:

```yaml
volumeMounts:
- mountPath: /etc/kubernetes/webhook
  name: webhook-config
  readOnly: true
```

```yaml
volumes:
- name: webhook-config
  hostPath:
    path: /etc/kubernetes/webhook
    type: DirectoryOrCreate
```

And you have to add dns configuration to kube-api server 

under `sepc` after `hostNetwork` field you can add below block

```
  dnsPolicy: ClusterFirstWithHostNet
  dnsConfig:
    nameservers:
    - 10.96.0.10
    searches:
    - default.svc.cluster.local
    - svc.cluster.local
```

Restart kubelet:

```
sudo systemctl restart kubelet
```

---

### 8) Create a test workload (should be denied if policy blocks implicit latest)

```
cat <<EOF > ~/nginx-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      tolerations:
      - key: node-role.kubernetes.io/control-plane
        operator: Exists
        effect: NoSchedule
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
EOF
```

</details>

---
