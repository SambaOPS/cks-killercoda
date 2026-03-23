## Step 2 – Apply the fixes

Still on `node01`:

```bash
vim /var/lib/kubelet/config.yaml
```

Find and update:
```yaml
authentication:
  anonymous:
    enabled: false      # ← was true
  webhook:
    enabled: true
authorization:
  mode: Webhook         # ← was AlwaysAllow
```

Reload and restart:
```bash
systemctl daemon-reload
systemctl restart kubelet
systemctl status kubelet | grep "Active:"
```

Verify anonymous access is blocked:
```bash
curl -sk https://localhost:10250/pods
# → Unauthorized (expected — this is correct!)
```

Return to control plane:
```bash
exit
kubectl get node node01
# → must be Ready
```

Click **Check** to validate.