# Ingress with HTTPS


## 🧩 Problem Statement

<details>
<summary>Click to expand the problem statement</summary>

There is an existing web application running in the `production` namespace behind a Service named **`web-service`**.

Your goal is to publish this application externally using an **Ingress** with **HTTPS**.

Create an Ingress resource called **`web-ingress`** in the `production` namespace with these requirements:

* Accept traffic for the hostname **`web.k8s.local`**
* Forward **all paths** (`/`) to the existing **web Service**
* Terminate TLS using the existing Secret **`web-ingress-tls`**
* Ensure plain HTTP requests are automatically **redirected to HTTPS**

You can validate the setup using:

```bash
curl -Lk https://web.k8s.local
```

</details>

---

## ✅ Solution

<details>
<summary>Click to expand the solution</summary>

Create an Ingress manifest like the one below and apply it.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: production
  annotations:
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - web.k8s.local
    secretName: web-ingress-tls
  rules:
  - host: web.k8s.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

Apply it:

```
kubectl apply -f web-ingress.yaml
```

Verify:

```
kubectl get ingress -n production
```

Test:

```
curl -Lk https://web.k8s.local
```

</details>

---

## 🛠 Scenario Setup

<details>
<summary>Click to expand setup steps</summary>

### 1) Install ingress-nginx (official manifest)

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.0/deploy/static/provider/cloud/deploy.yaml
```

Wait for controller Pods:

```
kubectl get pods -n ingress-nginx -w
```

If your environment does not support `LoadBalancer`, change the ingress controller Service to `NodePort`.

---

### 2) Add hosts entry (example using node IP)

Replace the IP with your node IP:

```
echo "10.0.1.39 web.k8s.local" | sudo tee -a /etc/hosts
```

---

### 3) Deploy sample app + service

```
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: production
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
  namespace: production
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
  namespace: production
spec:
  selector:
    app: web
  ports:
  - name: http
    port: 80
    targetPort: 80
EOF
```

---

### 4) Create TLS cert + Secret `web-ingress-tls`

```
mkdir -p ~/tls && cd ~/tls
```

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout web.k8s.local.key \
  -out web.k8s.local.crt \
  -subj "/CN=web.k8s.local"
```

Create the Secret in the same namespace as the Ingress (`production`):

```
kubectl -n production create secret tls web-ingress-tls \
  --cert=web.k8s.local.crt \
  --key=web.k8s.local.key
```

</details>

---