## Step 2 – Verify blocking

Try to create a violating pod:
```bash
kubectl run test-priv -n team-red \
  --image=nginx --restart=Never \
  --overrides='{"spec":{"containers":[{"name":"test","image":"nginx","securityContext":{"privileged":true}}]}}'
```

Expected output:
```
Error from server (Forbidden): pods "test-priv" is forbidden:
violates PodSecurity "baseline:latest": privileged
```

Check that Deployments create but pods don't run (error is in ReplicaSet events):
```bash
kubectl describe rs -n team-red 2>/dev/null | grep Warning || echo "No ReplicaSets"
```

Click **Check** to validate.