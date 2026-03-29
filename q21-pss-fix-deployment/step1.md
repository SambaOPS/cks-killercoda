## Step 1 – Diagnose

```bash
kubectl get pods -n pss-fix
# No pods running

kubectl get deploy violating-app -n pss-fix -o yaml > /tmp/fix.yaml

# See ALL violations at once
kubectl apply -f /tmp/fix.yaml --dry-run=server 2>&1
```

The `restricted` standard requires ALL of:
- `allowPrivilegeEscalation: false`
- `runAsNonRoot: true`
- `capabilities.drop: [ALL]`
- `seccompProfile.type: RuntimeDefault`  ← most often forgotten
- `privileged: false`