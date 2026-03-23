## Step 3 – Scale down the offending Deployments

```bash
kubectl scale deploy nvidia -n production --replicas=0
kubectl scale deploy cpu    -n production --replicas=0
kubectl scale deploy ollama -n production --replicas=0
```

Verify:

```bash
kubectl get deploy -n production
kubectl get pods -n production
# Should show no running pods
```

Click **Check** to validate your solution.