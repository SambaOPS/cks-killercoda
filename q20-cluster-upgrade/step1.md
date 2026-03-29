## Step 1 – Drain node01

```bash
kubectl get nodes
# Note the control plane version — that is the target

kubectl drain node01 \
  --ignore-daemonsets \
  --delete-emptydir-data \
  --force

kubectl get nodes
# node01 should show SchedulingDisabled
```