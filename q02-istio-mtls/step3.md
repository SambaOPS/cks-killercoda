## Step 3 – Restart to inject the sidecar

```bash
kubectl rollout restart deployment web-app -n secured-app
kubectl rollout status deployment web-app -n secured-app
```

Verify the sidecar is injected (pod should show **2/2**):

```bash
kubectl get pods -n secured-app
# NAME          READY   STATUS
# web-app-xxx   2/2     Running   ← 2/2 = app + istio-proxy
```

Click **Check** to validate.