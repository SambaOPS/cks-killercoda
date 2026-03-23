## Step 1 – Default deny all

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: backend
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF
```

Verify:
```bash
kubectl get networkpolicy -n backend
```

> After this, **ALL** traffic in/out of backend pods is blocked — including DNS!