# Kubernetes Worker Node Upgrade (kubeadm)


## 🧩 Problem Statement

<details>
<summary>Click to expand the problem statement</summary>

In a Kubernetes cluster initialized using **kubeadm**, the control plane has already been upgraded to a newer Kubernetes version.

However, one worker node was intentionally left on an older version to avoid disrupting active workloads.

You are required to:

* SSH into the worker node **`node01`**
* Safely upgrade its Kubernetes components
* Ensure it matches the **current control plane version**
* Perform the upgrade **without impacting running workloads**

---

### 📌 Important Notes

* Use the provided SSH access to connect to `node01`
* Only upgrade Kubernetes components (no application-level changes)
* After completing the upgrade, exit the node properly

</details>

---

## ✅ Solution

<details>
<summary>Click to expand the solution</summary>

### Step 1: Check current versions

From the control plane node:

```
kubectl get nodes
```

Example output:

```
NAME           STATUS   ROLES           AGE    VERSION
controlplane   Ready    control-plane   102m   v1.35.2
node01         Ready    <none>          64m    v1.33.1
```

Here, `node01` is running an older version.

---

### Step 2: SSH into the worker node

```
ssh node01
```

---

### Step 3: Upgrade kubeadm

Unhold kubeadm:

```
sudo apt-mark unhold kubeadm
```

Update package list:

```
sudo apt update
```

Install the required version (same as control plane):

```
sudo apt install -y kubeadm=1.35.2-*
```

---

### Step 4: Run kubeadm node upgrade

On worker nodes, use:

```
sudo kubeadm upgrade node
```

This updates the node configuration.

---

### Step 5: Upgrade kubelet and kubectl

Unhold packages:

```
sudo apt-mark unhold kubelet kubectl
```

Install the required versions:

```
sudo apt install -y kubelet=1.35.2-* kubectl=1.35.2-*
```

Hold them again (recommended):

```
sudo apt-mark hold kubeadm kubelet kubectl
```

---

### Step 6: Restart kubelet

```
sudo systemctl restart kubelet
```

---

### Step 7: Exit the worker node

```
exit
```

---

### Step 8: Verify upgrade

From control plane:

```
kubectl get nodes
```

Expected output:

```
NAME           STATUS   ROLES           AGE    VERSION
controlplane   Ready    control-plane   105m   v1.35.2
node02         Ready    <none>          67m    v1.33.2
```

The worker node is now successfully upgraded.

</details>

---

## 🛠 Setup Practice Scenario

<details>
<summary>Click to expand setup steps</summary>

### Step 1: Set up cluster with version 1.35

After initial setup:

```
kubectl get nodes
```

Example:

```
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   88m   v1.35.0
node01         Ready    <none>          50m   v1.35.0
```

---

### Step 2: Upgrade control plane to 1.35.2

`On control plane:`

```
sudo apt-mark unhold kubeadm
sudo apt update
sudo apt install -y kubeadm=1.35.2-*
```

Check upgrade plan:

```
sudo kubeadm upgrade plan
```

Apply upgrade:

```
sudo kubeadm upgrade apply v1.35.2
```

Upgrade kubelet and kubectl:

```
sudo apt-mark unhold kubelet kubectl
sudo apt install -y kubelet=1.35.2-* kubectl=1.35.2-*
sudo systemctl restart kubelet
```


`On Worker node:`

```
sudo apt-mark unhold kubeadm
sudo apt update
sudo apt install -y kubeadm=1.35.1-*
```

Check upgrade plan:

```
sudo kubeadm upgrade plan
```

Apply upgrade:

```
sudo kubeadm upgrade apply v1.35.1
```

Upgrade kubelet and kubectl:

```
sudo apt-mark unhold kubelet kubectl
sudo apt install -y kubelet=1.35.1-* kubectl=1.35.1-*
sudo systemctl restart kubelet
```

Now the control plane runs `v1.35.2`, while the worker on `v1.35.1`.


---

### Step 3: SSH Configuration from Control Plane to Worker Node

Run the following command on the **control plane node** to generate an SSH key:

```bash
ssh-keygen -t rsa -b 2046
```

When prompted, press **Enter** for all options until the SSH keys are created.

---

#### Copy the Public Key

Run the following command to display the public key:

```bash
cat ~/.ssh/id_rsa.pub
```

Copy the output of this command.

---

#### Add the Public Key to the Worker Node

Login to the **worker node** and paste the copied public key into the following file:

```bash
vim ~/.ssh/authorized_keys
```

Paste the key, then **save and exit**.

---

#### Configure SSH Shortcut on the Control Plane

On the **control plane node**, open the SSH configuration file:

```bash
vim ~/.ssh/config
```

Add the following configuration:

```bash
Host node01
    HostName <node-ip>
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
```

Save the file and exit.

---

#### Test the Connection

Now test the SSH connection from the **control plane node**:

```bash
ssh node01
```

Apply the solution steps to upgrade the worker node.

</details>

---
