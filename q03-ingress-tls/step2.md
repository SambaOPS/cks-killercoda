## Step 2 – Create the Ingress

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: web
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - web.example.com
    secretName: web-tls
  rules:
  - host: web.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-svc
            port:
              number: 80
EOF
```

> **⚠ Traps:**
> - `ssl-redirect: "true"` is a **string**, not a boolean
> - `spec.tls.hosts` must match `rules.host` exactly
> - `ingressClassName: nginx` is mandatory

Click **Check** to validate.