## Step 2 – Update the Deployment

```bash
kubectl patch deploy untrusted-app -n team-purple --type=json -p='[
  {"op":"add","path":"/spec/template/spec/runtimeClassName","value":"gvisor"},
  {"op":"add","path":"/spec/template/spec/nodeName","value":"node01"}
]'

kubectl rollout status deploy untrusted-app -n team-purple
```

Verify gVisor is running:
```bash
kubectl exec -n team-purple deploy/untrusted-app -- dmesg | head -3
# → Starting gVisor...
```

Click **Check** to validate.