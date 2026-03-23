## Step 1 – Drain node01

```bash
# Check versions
kubectl get nodes
# controlplane   Ready   v1.3X.Y   ← target
# node01         Ready   v1.3X.Z   ← one version behind

# Drain the node safely
kubectl drain node01 \
  --ignore-daemonsets \
  --delete-emptydir-data \
  --force

# Confirm node is SchedulingDisabled
kubectl get nodes
```

> After drain: workloads are evicted, node shows `SchedulingDisabled`.