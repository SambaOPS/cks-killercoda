## Step 2 – Apply all fixes

**Backup first:**
```bash
cp /etc/kubernetes/manifests/kube-apiserver.yaml{,.bak}
```

Edit the manifest:
```bash
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

Find and set/update these flags (change existing values, don't add duplicates):
```yaml
- --anonymous-auth=false       # 1.2.1
- --profiling=false            # 1.2.12
- --authorization-mode=Node,RBAC  # 1.2.16 (was AlwaysAllow)
- --insecure-port=0            # 1.2.19
```

**File permission fixes:**
```bash
# 1.1.12 — etcd data directory
chown -R etcd:etcd /var/lib/etcd
stat -c "%U:%G" /var/lib/etcd

# 4.1.9 — kubelet config
chmod 600 /var/lib/kubelet/config.yaml
stat -c "%a" /var/lib/kubelet/config.yaml
```

> **⚠ Trap:** If `--authorization-mode` already exists with a wrong value, **change** it — don't add a second one. Two identical flags = crash.

Click **Check** to validate.