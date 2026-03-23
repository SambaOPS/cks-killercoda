## Step 1 – Enable sidecar injection

Label the namespace:

```bash
kubectl label namespace secured-app istio-injection=enabled

# Verify the label
kubectl get namespace secured-app --show-labels
```

> **⚠ Trap:** Labeling the namespace does NOT retroactively inject sidecars into existing pods. You must restart them.