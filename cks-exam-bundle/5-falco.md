# Detecting a Pod Accessing `/dev/mem`


## 🧩 Problem Statement

<details>
<summary>Click to expand the problem statement</summary>

A suspicious Pod in the cluster has been flagged for abnormal behavior.

A Pod belonging to the **neuron** application is attempting to access the sensitive host device:

```
/dev/mem
```

This indicates a potential security threat and must be stopped.

---

### 🎯 Task

1. Identify the Pod that is accessing `/dev/mem`.
2. Scale the Deployment of the identified Pod down to **zero replicas**.

</details>

---

## ✅ Solution

<details>
<summary>Click to expand the solution</summary>

### Step 1: Check Pods in the `neuron` namespace

```
kubectl get pods -n neuron
```

---

### Step 2: Create a Falco rule to detect `/dev/mem` access

Edit Falco local rules file:

```
sudo vim /etc/falco/falco_rules.local.yaml
```

Add the following rule:

```yaml
- list: sensitive_devices
  items: [/dev/mem]

- rule: Container Accesses /dev/mem
  desc: Detect containers attempting to read or write /dev/mem
  condition: >
    evt.type in (open, openat, openat2) and fd.name in (sensitive_devices)
  output: >
    container_id=%container.id 
  priority: CRITICAL
```

Save and exit.

---

### Step 3: Run Falco using the local rules

Run Falco in the foreground so you can immediately see events:

```
sudo falco -r /etc/falco/falco_rules.local.yaml
```

When the suspicious access happens, Falco will print an alert including:

* `container_id`
* Kubernetes namespace
* Pod name (often available as `k8s.pod`)
* Container name

Example (illustration):

```
Suspicious /dev/mem access ... container_id=abcd1234 k8s.ns=neuron k8s.pod=neuron-xxx
```

---

### Step 4: Map container ID to Pod/Deployment (if needed)

If Falco output includes the Pod name already, you can skip this step.

Otherwise, use CRI tooling to identify the container:

```
sudo crictl ps | grep <container-id>
```

Then find the Pod and Deployment via Kubernetes labels:

```
kubectl get pod -n neuron -o wide
kubectl describe pod -n neuron <pod-name>
```

---

### Step 5: Scale the Deployment down to 0 replicas

Once you identify the Deployment, scale it down:

```
kubectl scale deployment -n neuron <deployment-name> --replicas=0
```

Verify:

```
kubectl get deploy,pods -n neuron
```

Pods for that Deployment should terminate.

</details>

---

## 🛠 Setup Practice Scenario

<details>
<summary>Click to expand setup steps</summary>

### Step 1: Create namespace

```
kubectl create namespace neuron
```

---

### Step 2: Deploy sample workloads in `neuron`

```
kubectl create deployment facebook -n neuron --image=devopstechtales/cks-exam-questions:falco-eg-v1
kubectl create deployment instagram -n neuron --image=devopstechtales/cks-exam-questions:falco-eg-v2
kubectl create deployment tinder -n neuron --image=devopstechtales/cks-exam-questions:falco-eg-v3
```

---

### Step 3: Install Falco

```
sudo apt update
sudo apt install -y curl gnupg2 apt-transport-https
```

```
curl -fsSL https://falco.org/repo/falcosecurity-packages.asc \
  | sudo gpg --dearmor -o /usr/share/keyrings/falco-archive-keyring.gpg
```

```
echo "deb [signed-by=/usr/share/keyrings/falco-archive-keyring.gpg] https://download.falco.org/packages/deb stable main" \
  | sudo tee /etc/apt/sources.list.d/falcosecurity.list
```

```
sudo apt update
sudo apt install -y falco
```

Check status:

```
sudo systemctl status falco
```

(Optional) Stop system service if you want to run Falco manually in the foreground:

```
sudo systemctl stop falco
```

Now apply the Solution section steps to detect `/dev/mem` access.

</details>

---
