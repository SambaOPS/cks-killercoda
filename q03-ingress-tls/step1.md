## Step 1 – Inspect existing resources

```bash
kubectl get secret web-tls -n web
kubectl get svc web-svc -n web
kubectl get ingressclass
```

Confirm:
- Secret type should be `kubernetes.io/tls`
- IngressClass `nginx` should be available