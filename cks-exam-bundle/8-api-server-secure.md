# Securing API Server Authentication & Authorization


## 🧩 Problem Statement

<details>
<summary>Click to expand the problem statement</summary>

A Kubernetes cluster built using **kubeadm** was temporarily left in an insecure state for testing purposes.

The API server is currently configured to allow requests without proper authentication and authorization. This presents a serious security risk.

Your task is to restore secure access controls by hardening the API server configuration and removing any anonymous permissions.

---

### 🎯 Task

Update the Kubernetes API server configuration to enforce the following security settings:

1. Disable **anonymous authentication**
2. Configure authorization to use only:

   * `Node`
   * `RBAC`
3. Enable the admission controller:

   * `NodeRestriction`

After securing the API server, remove unnecessary anonymous access by deleting the following ClusterRoleBinding:

```
system:anonymous
```

</details>

---

## ✅ Solution

<details>
<summary>Click to expand the solution</summary>

### Step 1: Edit the kube-apiserver manifest

On the control plane node, open:

```
sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

Add or update the following flags under the `command:` section:

```
- --anonymous-auth=false
- --authorization-mode=Node,RBAC
- --enable-admission-plugins=NodeRestriction
```

⚠️ Important:

* If `--authorization-mode` already exists, modify it instead of duplicating.
* If `--enable-admission-plugins` already exists, append `NodeRestriction` to the existing list.
* Avoid overwriting other required admission plugins.

Save and exit.

Since this is a static Pod, the kubelet will automatically restart the API server.

---

### Step 2: Verify API server is running

If anonymous authentication is disabled, unauthenticated `kubectl` calls may fail.

You can verify the API server using:

```
sudo crictl ps | grep kube-apiserver
```

Or use the admin kubeconfig:

```
kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes
```

If nodes are listed successfully, the API server is healthy.

---

### Step 3: Remove anonymous ClusterRoleBinding

List ClusterRoleBindings:

```
kubectl --kubeconfig=/etc/kubernetes/admin.conf get clusterrolebinding | grep anonymous
```

You should see:

```
system:anonymous
```

Delete it:

```
kubectl --kubeconfig=/etc/kubernetes/admin.conf delete clusterrolebinding system:anonymous
```

---

### Step 4: Confirm removal

```
kubectl --kubeconfig=/etc/kubernetes/admin.conf get clusterrolebinding | grep anonymous
```

There should be no output.

---

### Step 5: Final verification

Confirm cluster health:

```
kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes
kubectl --kubeconfig=/etc/kubernetes/admin.conf get pods -A
```

All nodes and Pods should remain in `Ready` and `Running` state.

</details>



## 🛠 Scenario Setup (Practice Lab)

<details>
<summary>Click to expand setup steps</summary>

---

### Step 1 — Save admin access first
```bash
sudo cp /etc/kubernetes/admin.conf ~/.kube/admin.conf
sudo chown $(id -u):$(id -g) ~/.kube/admin.conf
```

### Step 2 — Get API Server IP
```bash
APISERVER_IP=$(grep server $HOME/.kube/admin.conf | awk -F'https://' '{print $2}' | awk -F':' '{print $1}')
echo $APISERVER_IP
```


### Step 3 — Create anonymous kubeconfig
```bash
kubectl config set-cluster kubernetes \
  --server=https://${APISERVER_IP}:6443 \
  --insecure-skip-tls-verify=true \
  --kubeconfig=$HOME/.kube/config
```

### Step 4 — Set credentials as system:anonymous
```bash
kubectl config set-credentials anon \
  --username=system:anonymous \
  --password=anything \
  --kubeconfig=$HOME/.kube/config
```

### Step 5 — Set context
```bash
kubectl config set-context anonymous-context \
  --cluster=kubernetes \
  --user=anon \
  --kubeconfig=$HOME/.kube/config
```

### Step 6 — Use that context
```bash
kubectl config use-context anonymous-context \
  --kubeconfig=$HOME/.kube/config
```

### Step 7 — Grant system:anonymous cluster-admin
```bash
kubectl --kubeconfig=$HOME/.kube/admin.conf \
  create clusterrolebinding system:anonymous \
  --clusterrole=cluster-admin \
  --user=system:anonymous
```

---

</details>

---