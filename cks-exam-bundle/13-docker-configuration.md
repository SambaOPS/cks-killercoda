# Securing the Docker Daemon


## 🧩 Problem Statement

<details>
<summary>Click to expand the problem statement</summary>

A Kubernetes worker node requires immediate hardening due to insecure Docker daemon configuration.

The node currently:

* Allows unnecessary user-level access to the Docker socket
* May be exposing the Docker API over the network

Both issues can lead to serious security risks.

You must log in to node **`cks000037`** and apply the required security fixes without impacting cluster stability.

---

### 🎯 Task

On node, complete the following:

1. Remove user **`developer`** from the `docker` group

   * Do not remove the user from any other groups

2. Update and restart Docker so that:

   * `/var/run/docker.sock` is owned by the **root group**

3. Ensure Docker is **not listening on any TCP port**

   * It should only use the Unix socket

---

### 📌 Notes

* Restart Docker after applying changes
* Confirm the Kubernetes cluster remains healthy

</details>

---

## ✅ Solution

<details>
<summary>Click to expand the solution</summary>

---

### Step 1: Check if `developer` belongs to the docker group

```
id developer
```

Example output:

```
uid=1001(developer) gid=1001(developer) groups=1001(developer),988(docker)
```

---

### Step 2: Remove `developer` from docker group

```
sudo gpasswd -d developer docker
```

Verify:

```
id developer
```

Now it should no longer show `docker` in the group list.

---

### Step 3: Fix Docker socket group ownership

Check current socket permissions:

```
ls -lh /var/run/docker.sock
```

If the group is `docker`, update it.

Edit the systemd socket file:

```
sudo vim /usr/lib/systemd/system/docker.socket
```

Change:

**From**

```
SocketGroup=docker
```

**To**

```
SocketGroup=root
```

Save and reload systemd:

```
sudo systemctl daemon-reload
sudo systemctl restart docker.socket
```

Verify again:

```
ls -lh /var/run/docker.sock
```

Expected:

```
srw-rw---- 1 root root ...
```

---

### Step 4: Ensure Docker is not listening on TCP port 2375

Check listening ports:

```
sudo netstat -tunlp | grep 2375
```

If you see:

```
tcp6  0  0 :::2375  :::*  LISTEN
```

Docker is exposed over TCP.

---

### Step 5: Remove TCP listener from Docker service

Edit the service file:

```
sudo vim /usr/lib/systemd/system/docker.service
```

Remove this option from `ExecStart`:

```
-H tcp://0.0.0.0:2375
```

It should look similar to:

```
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```

Reload and restart Docker:

```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

---

### Step 6: Verify TCP port is closed

```
sudo netstat -tunlp | grep 2375
```

No output should appear.

---

### Step 7: Verify cluster health

From control plane:

```
kubectl get nodes
kubectl get pods -A
```

All nodes and Pods should remain in `Ready` and `Running` state.

</details>

---

## 🛠 Setup Practice Scenario

<details>
<summary>Click to expand setup steps</summary>

> ⚠️ You can test this on a standalone VM or a kubeadm cluster using Docker as the runtime.

---

### 1) Install Docker on Ubuntu

```
sudo apt update
sudo apt install ca-certificates curl
```

Add Docker repo:

```
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Add repository:

```
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
```

Install Docker:

```
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

---

### 2) Create insecure configuration for testing

Create user:

```
sudo useradd developer
```

Add user to docker group:

```
sudo usermod -aG docker developer
```

Verify:

```
id developer
```

---

### 3) Make Docker listen on TCP 2375

Edit service file:

```
sudo vim /usr/lib/systemd/system/docker.service
```

Modify `ExecStart`:

```
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock
```

Reload and restart:

```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

Check port:

```
sudo netstat -tunlp | grep 2375
```

Now apply the solution steps to harden the configuration.

</details>