# Creating a TLS Secret for an Existing Web Deployment


## 🧩 Problem Statement

<details>
<summary>Click to expand the problem statement</summary>

A Kubernetes web application is already running in the cluster, but secure HTTPS access has not been configured.

To enable encrypted communication, SSL certificate and private key files are available on the node. These must be stored inside Kubernetes as a **TLS Secret**.

---

### 🎯 Task

Create a TLS Secret named **`bright-banyan`** in the **`bright-banyan`** namespace.

The Secret must be created using the following SSL files:

* Certificate file:
  `/home/ubuntu/tls/banyan.crt`

* Private key file:
  `/home/ubuntu/tls/banyan.key`

An existing Deployment named **`bright-banyan`** is already configured to reference this Secret.

---

### 📌 Important Notes

* ❌ Do NOT modify the Deployment.
* ✅ Only create the required TLS Secret.
* ✅ Ensure the Secret type is `kubernetes.io/tls`.
* ✅ Create it in the correct namespace.

</details>

---

## ✅ Solution

<details>
<summary>Click to expand the solution</summary>

### Step 1: Verify Deployment Status

Check whether the Deployment exists and its current status:

```
kubectl get deployment -n bright-banyan
```

You may see `0/1` READY because the required Secret does not exist yet.

---

### Step 2: Create the TLS Secret

Use the provided certificate and key files:

```
kubectl create secret tls bright-banyan \
  -n bright-banyan \
  --cert=/home/ubuntu/tls/banyan.crt \
  --key=/home/ubuntu/tls/banyan.key
```

This automatically creates a Secret of type:

```
kubernetes.io/tls
```

---

### Step 3: Verify Secret

```
kubectl get secret bright-banyan -n bright-banyan
```

Optional detailed check:

```
kubectl describe secret bright-banyan -n bright-banyan
```

---

### Step 4: Verify Deployment Status

```
kubectl get deployment -n bright-banyan
```

The Deployment should now show:

```
1/1 READY
```

This confirms the Secret was created correctly and mounted successfully.

</details>

---

## 🛠 Setup Practice Scenario


<details>
<summary>Click to expand setup steps</summary>

---

### Step 1: Create TLS Files

```
mkdir -p /home/ubuntu/tls
cd /home/ubuntu/tls
```

Generate a self-signed certificate:

```
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout banyan.key \
  -out banyan.crt \
  -subj "/CN=web.k8s.local"
```

---

### Step 2: Create Namespace

```
kubectl create namespace bright-banyan
```

---

### Step 3: Create Deployment Referencing TLS Secret

```
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bright-banyan
  namespace: bright-banyan
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bright-banyan
  template:
    metadata:
      labels:
        app: bright-banyan
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        ports:
        - containerPort: 443
        volumeMounts:
        - name: tls-cert
          mountPath: /etc/nginx/tls
          readOnly: true
      volumes:
      - name: tls-cert
        secret:
          secretName: bright-banyan
EOF
```

At this stage:

* The Deployment will fail because the Secret does not exist.
* Now apply the solution steps to fix the issue.

</details>

---
