# Restricted Pod Security Standard (PSA)


## 🧩 Problem Statement

<details>
<summary>Click to expand the problem statement</summary>

A Kubernetes cluster is configured to enforce the **Restricted Pod Security Standard** across all user namespaces.

In the `restricted` namespace, an existing Deployment is not meeting the required Restricted security rules. Because of this, its Pods are being rejected and cannot be scheduled or started.

The Deployment manifest file is available at:

```
~/nginx-deployment.yaml
```

---

### 🎯 Task

* Update the Deployment in the `restricted` namespace so that it fully complies with the **Restricted Pod Security Standard**.
* After applying the required security settings, verify that the Pods are created and running successfully.

---

### 📌 Notes

* Modify only what is required for Restricted compliance.
* Ensure the workload can be scheduled and runs normally after the fix.

</details>

---

## ✅ Solution

<details>
<summary>Click to expand the solution</summary>

### Step 1: Check the Deployment status

Verify the Deployment in the `restricted` namespace:

```
kubectl get deploy -n restricted
```

If it shows `0/1` and no Pods are created, the Pod Security Admission policy is likely rejecting the Pod.

You can confirm by checking events:

```
kubectl get events -n restricted --sort-by=.lastTimestamp
```

---

### Step 2: Update the Deployment manifest

Edit the manifest file:

```
vim ~/nginx-deployment.yaml
```

Add the following `securityContext` at the **container level**:

```yaml
securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop: ["ALL"]
  runAsNonRoot: true
  seccompProfile:
    type: RuntimeDefault
```

Make sure it is placed under the container (example):

```yaml
spec:
  template:
    spec:
      containers:
      - name: nginx
        image: nginxinc/nginx-unprivileged
        ports:
        - containerPort: 80
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop: ["ALL"]
          runAsNonRoot: true
          seccompProfile:
            type: RuntimeDefault
```

Save and exit.

---

### Step 3: Apply the updated manifest

```
kubectl apply -f ~/nginx-deployment.yaml
```

---

### Step 4: Verify Pods are running

```
kubectl get pods -n restricted
```

If the Pods are running normally, the Deployment now complies with the Restricted Pod Security Standard.

</details>

---

## 🛠 Setup Practice Scenario

<details>
<summary>Click to expand setup steps</summary>

### Step 1: Create the namespace

```
kubectl create namespace restricted
```

---

### Step 2: Enforce Restricted PSA on the namespace

```
kubectl label namespace restricted pod-security.kubernetes.io/enforce=restricted
```

(Optional) Verify labels:

```
kubectl get ns restricted --show-labels
```

---

### Step 3: Create a sample Deployment manifest

Create the file:

```
vim ~/nginx-deployment.yaml
```

Paste this content (intentionally missing Restricted settings):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-unprivileged
  namespace: restricted
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
      containers:
      - name: nginx
        image: nginxinc/nginx-unprivileged
        ports:
        - containerPort: 80
```

---

### Step 4: Apply the Deployment

```
kubectl apply -f ~/nginx-deployment.yaml
```

This will typically fail under Restricted PSA until you add the required securityContext.
Now apply the solution steps to make it compliant.

</details>

---
