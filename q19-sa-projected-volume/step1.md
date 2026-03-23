## Step 1 – Disable automount

```bash
kubectl patch serviceaccount api-sa -n token-test \
  -p '{"automountServiceAccountToken": false}'

kubectl get sa api-sa -n token-test -o yaml | grep automount
# → automountServiceAccountToken: false
```

> **⚠ Trap:** There are TWO levels of automount:
> - SA level: `automountServiceAccountToken: false`
> - Pod level: `spec.automountServiceAccountToken: false`
>
> The pod spec overrides the SA. Set both for defense-in-depth.