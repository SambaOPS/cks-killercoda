## Step 1 – Inspect the provided files

```bash
ls /etc/kubernetes/admission/
cat /etc/kubernetes/admission/admission-config.yaml
```

**Fix `defaultAllow` first:**
```bash
grep "defaultAllow" /etc/kubernetes/admission/admission-config.yaml
# If true, change to false:
sed -i 's/defaultAllow: true/defaultAllow: false/'   /etc/kubernetes/admission/admission-config.yaml
```

> **defaultAllow: false** = fail-closed = deny all images if backend is down.