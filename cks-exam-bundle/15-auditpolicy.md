# 📝 Kubernetes API Log Auditing


## 🧩 Problem Statement

<details>
<summary>Click to expand the problem statement</summary>

A kubeadm-based Kubernetes cluster does **not** have API auditing enabled.

You must:

1. Enable auditing on the API server using an existing baseline audit policy file.
2. Ensure audit logs are written to disk with proper rotation and retention settings.
3. Extend the baseline audit policy to capture additional specific API requests.

---

### 🎯 Required Audit Behavior

Your extended policy must ensure:

* The **`namespace`** resource is logged at **RequestResponse** level
  *(In your exam this may reference another resource like PersistentVolumes.)*

* **ConfigMap** requests in the **`frontend`** namespace must log **request bodies**

* Updates/changes to **ConfigMaps** and **Secrets** in **all namespaces** must be logged at **Metadata** level

* Everything else should default to **Metadata** level

Finally, confirm the API server is using your updated audit policy.

</details>

---

## ✅ Solution

<details>
<summary>Click to expand the solution</summary>

---

### Step 1: Extend the audit policy

Edit the baseline policy file:

```bash
sudo vim /etc/kubernetes/logpolicy/sample-policy.yaml
```

Append the following rules **after existing rules**, ensuring proper order:

```yaml
  # 1) Log namespaces at RequestResponse level
  - level: RequestResponse
    resources:
    - group: ""
      resources: ["namespaces"]

  # 2) Log request bodies for ConfigMaps in frontend namespace
  - level: Request
    namespaces: ["frontend"]
    resources:
    - group: ""
      resources: ["configmaps"]

  # 3) Log ConfigMaps and Secrets in all namespaces at Metadata level
  - level: Metadata
    verbs: ["create", "update", "patch", "delete"]
    resources:
    - group: ""
      resources: ["configmaps", "secrets"]

  # 4) Default rule for everything else
  - level: Metadata
    omitStages:
    - "RequestReceived"
```

⚠️ Important:
Audit rules are evaluated **top-down**.
More specific rules must appear **before** broader/default rules.

---

### Step 2: Enable auditing on kube-apiserver (static pod)

Edit the API server manifest:

```bash
sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

Ensure the following flags are present under `command:`:

```yaml
- --audit-policy-file=/etc/kubernetes/logpolicy/sample-policy.yaml
- --audit-log-path=/var/log/kubernetes/audit-logs.txt
- --audit-log-maxage=10
- --audit-log-maxbackup=2
- --audit-log-maxsize=100
```

Explanation:

* `audit-policy-file` → Path to policy
* `audit-log-path` → File location
* `maxage` → Days to retain logs
* `maxbackup` → Number of rotated files
* `maxsize` → Max size (MB) before rotation

Since kube-apiserver runs as a **static pod**, kubelet will automatically restart it after saving.

---

### Step 3: Verify audit logs

Check whether logs are being written:

```bash
sudo tail -n 50 /var/log/kubernetes/audit-logs.txt
```

Generate activity for testing:

```bash
kubectl create namespace test-audit
kubectl create configmap cm-test --from-literal=key=value -n frontend
```

Check logs again to confirm entries.

</details>

---

## 🛠 Scenario Setup (Practice Lab)

<details>
<summary>Click to expand setup steps</summary>

---

### Step 1: Create required directories

```bash
sudo mkdir -p /etc/kubernetes/logpolicy
sudo mkdir -p /var/log/kubernetes
sudo touch /var/log/kubernetes/audit-logs.txt
```

---

### Step 2: Create baseline audit policy

```bash
sudo tee /etc/kubernetes/logpolicy/sample-policy.yaml >/dev/null <<'EOF'
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
  - level: None
    resources:
    - group: ""
      resources: ["configmaps"]
      resourceNames: ["controller-leader"]

  - level: None
    users: ["system:kube-proxy"]
    verbs: ["watch"]
    resources:
    - group: ""
      resources: ["endpoints", "services"]
EOF
```

---

### Step 3: Mount audit policy + log directory in kube-apiserver

Edit:

```bash
sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

Under `volumeMounts:`:

```yaml
- name: audit-policy
  mountPath: /etc/kubernetes/logpolicy
  readOnly: true
- name: audit-logs
  mountPath: /var/log/kubernetes
```

Under `volumes:`:

```yaml
- name: audit-policy
  hostPath:
    path: /etc/kubernetes/logpolicy
    type: DirectoryOrCreate
- name: audit-logs
  hostPath:
    path: /var/log/kubernetes
    type: DirectoryOrCreate
```

Save and exit — kubelet will restart the API server automatically.

</details>

---