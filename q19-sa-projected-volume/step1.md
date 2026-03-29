## Step 1 – Disable automount on the ServiceAccount

```bash
kubectl patch serviceaccount api-sa -n token-test \
  -p '{"automountServiceAccountToken": false}'

kubectl get sa api-sa -n token-test -o yaml | grep automount
# → automountServiceAccountToken: false
```

> **⚠ Two levels:** The pod spec overrides the SA setting. Disable both for defense-in-depth.