## Step 2 – Create the Ingress with TLS

> **✅ Doc autorisée pendant l'exam :** `https://kubernetes.github.io/ingress-nginx`
> Tu peux y chercher les annotations nginx (ssl-redirect, force-ssl-redirect, etc.)

Apply the Ingress:

```bash
kubectl apply -f - <<'YAML'
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
YAML
```

Verify:

```bash
kubectl get ingress web-ingress -n web
kubectl describe ingress web-ingress -n web | grep -E "TLS|Rules|Annotations"
```

> **Pièges à l'exam :**
> - ssl-redirect: "true" est une STRING avec guillemets — pas un boolean
> - spec.tls[].hosts[] doit correspondre EXACTEMENT à rules[].host
> - ingressClassName: nginx est obligatoire (K8s >= 1.22)
> - Toujours specifier le namespace : metadata.namespace: web

Click **Check** to validate.
