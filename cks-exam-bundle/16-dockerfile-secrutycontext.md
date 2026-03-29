# 🛡 Dockerfile & Deployment Hardening Review

## 🧩 Problem Statement

<details>
<summary>Click to expand the problem statement</summary>

A containerized application is prepared for deployment, but a security review identified poor practices in both:

* The Docker image configuration
* The Kubernetes deployment configuration

You must review and fix **one insecure instruction** in the Dockerfile and **one insecure field** in the Kubernetes manifest.

Dockerfile path:

```
/cks/docker/Dockerfile
```

Kubernetes manifest path:

```
/cks/docker/deployment.yaml
```

---

### ✅ Important Constraints

* Do **not** build the Docker image after making changes
* Do **not** add new configuration blocks
* Do **not** remove existing configuration sections
* Only **modify the insecure instruction or field**
* If a non-root user is required in Dockerfile, use:

  ```
  USER 65535
  ```

(the `nobody` user)

</details>

---

## ✅ Solution

<details>
<summary>Click to expand the solution</summary>

### Step 1: Fix the insecure Dockerfile instruction

Open the Dockerfile:

```
vim /cks/docker/Dockerfile
```

Change:

**From**

```
USER root
```

**To**

```
USER 65535
```

Save and exit.

⚠️ Do not build the image after this change.

---

### Step 2: Fix the insecure Kubernetes manifest field

Open the deployment manifest:

```
vim /cks/docker/deployment.yaml
```

Update only the existing `securityContext` fields:

**From**

```yaml
securityContext:
  privileged: true
  readOnlyRootFilesystem: false
  runAsUser: 0
```

**To**

```yaml
securityContext:
  privileged: false
  readOnlyRootFilesystem: true
  runAsUser: 65535
```

Save and exit.

</details>

---

## 🛠 Setup Practice Scenario

<details>
<summary>Click to expand setup steps</summary>

### Step 1: Create folder structure

```bash
mkdir -p /cks/docker
cd /cks/docker
```

---

### Step 2: Create Dockerfile (intentionally insecure)

```bash
sudo tee /cks/docker/Dockerfile <<'EOF'
FROM nginx:1.27

LABEL maintainer="devops-team"

RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

COPY ./html /usr/share/nginx/html

RUN chown -R root:root /usr/share/nginx/html

USER root

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF
```

---

### Step 3: Create Deployment manifest (intentionally insecure)

```bash
sudo tee /cks/docker/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secure-app
  template:
    metadata:
      labels:
        app: secure-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        securityContext:
          privileged: true
          readOnlyRootFilesystem: false
          runAsUser: 0
EOF
```

Now apply the Solution section changes only (no build required).

</details>

---