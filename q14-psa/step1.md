## Step 1 – Apply PSS and clean up

```bash
kubectl label namespace team-red \
  pod-security.kubernetes.io/enforce=baseline \
  pod-security.kubernetes.io/warn=baseline \
  pod-security.kubernetes.io/enforce-version=latest

# Verify
kubectl get ns team-red --show-labels | grep pod-security
```

> **⚠ Critical trap:** `enforce` does NOT evict existing non-compliant pods.
> You must delete them manually.

Delete the non-compliant pod:
```bash
kubectl delete pod privileged-pod -n team-red
kubectl get pods -n team-red
```