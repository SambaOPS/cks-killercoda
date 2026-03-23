## Step 1 – Inspect the kubelet configuration

```bash
ssh node01

# Find which config file kubelet uses
ps aux | grep kubelet | grep -o '\-\-config [^ ]*'
# → /var/lib/kubelet/config.yaml

# Inspect current values
grep -A3 "authentication:" /var/lib/kubelet/config.yaml
grep "mode:" /var/lib/kubelet/config.yaml
```

You should see `anonymous.enabled: true` and `mode: AlwaysAllow`.

> **⚠ Trap:** Always verify which config file is actually being used before editing.