## Step 1 – Diagnose violations

Check why pods aren't running:
```bash
kubectl get pods -n pss-fix
kubectl describe replicaset -n pss-fix | grep -A10 "Warning"
```

Use dry-run to see all violations:
```bash
kubectl get deploy violating-app -n pss-fix -o yaml > /tmp/violating-app.yaml
kubectl apply -f /tmp/violating-app.yaml --dry-run=server 2>&1
```

The `restricted` standard requires ALL of these:
- `allowPrivilegeEscalation: false`
- `runAsNonRoot: true`
- `capabilities.drop: [ALL]`
- `seccompProfile.type: RuntimeDefault`
- `privileged: false`