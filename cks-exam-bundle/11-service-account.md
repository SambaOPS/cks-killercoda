# Hardening ServiceAccount Token Usage


## 🧩 Problem Statement

<details>
<summary>Click to expand the problem statement</summary>

A security review found that a workload in the **`serviceaccount`** namespace is handling ServiceAccount tokens in a way that does not meet compliance requirements.

You must harden token usage for the existing monitoring components.

---

### 🎯 Tasks

1. Update the **ServiceAccount** `monitor-sa` in the `serviceaccount` namespace so that Kubernetes **does not automatically mount API credentials** into Pods using this ServiceAccount.

2. Update the **Deployment** `monitor` (in the same namespace) so that it still receives a ServiceAccount token, but **only through an explicitly defined projected volume**:

   * The projected volume must be named **`token`**
   * The token file must be mounted at:

     ```
     /var/run/secrets/kubernetes.io/serviceaccount/token
     ```
   * The mount must be **read-only**

Reference manifest:

```
~/monitor/deployment.yaml
```

</details>

---

## ✅ Solution

<details>
<summary>Click to expand the solution</summary>

You are allowed to refer to the official Kubernetes documentation if needed.

---

### Step 1: Disable Automatic Token Mounting

Edit the ServiceAccount:

```
kubectl edit serviceaccount monitor-sa -n serviceaccount
```

Add the following field:

```yaml
automountServiceAccountToken: false
```

Save and exit.

This prevents Kubernetes from automatically injecting API credentials into Pods using this ServiceAccount.

---

### Step 2: Update the Deployment

Open the Deployment manifest:

```
vim ~/monitor/deployment.yaml
```

Modify the Pod spec as follows:

```yaml
spec:
  serviceAccountName: monitor-sa
  automountServiceAccountToken: false
  containers:
  - name: monitor
    image: nginx
    ports:
    - containerPort: 80
    volumeMounts:
    - name: token
      mountPath: /var/run/secrets/kubernetes.io/serviceaccount/token
      readOnly: true
  volumes:
  - name: token
    projected:
      sources:
      - serviceAccountToken:
          path: token
          expirationSeconds: 3600
```

Save the file and apply it:

```
kubectl apply -f ~/monitor/deployment.yaml
```

Now the Pod will:

* Not receive automatically mounted credentials
* Receive a token only through the explicitly defined projected volume
* Mount it as read-only at the required path

</details>

---

## 🛠 Setup Practice Scenario

<details>
<summary>Click to expand setup steps</summary>

---

### Step 1: Create Namespace

```
kubectl create namespace serviceaccount
```

---

### Step 2: Create ServiceAccount

```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: monitor-sa
  namespace: serviceaccount
EOF
```

---

### Step 3: Create Deployment Manifest

```
mkdir -p ~/monitor
```

```
cat <<EOF > ~/monitor/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: monitor
  namespace: serviceaccount
spec:
  replicas: 1
  selector:
    matchLabels:
      app: monitor
  template:
    metadata:
      labels:
        app: monitor
    spec:
      serviceAccountName: monitor-sa
      containers:
      - name: monitor
        image: nginx
        ports:
        - containerPort: 80
EOF
```

Apply the Deployment:

```
kubectl apply -f ~/monitor/deployment.yaml
```

At this stage, the ServiceAccount token is automatically mounted.

Now apply the solution steps to harden token handling.

</details>

---
