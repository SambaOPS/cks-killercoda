## Step 2 – Edit the kube-apiserver manifest

```bash
cp /etc/kubernetes/manifests/kube-apiserver.yaml{,.bak}
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

**Find the `--enable-admission-plugins` flag and APPEND** `ImagePolicyWebhook`:
```yaml
- --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook
```
> ⚠ Don't create a second `--enable-admission-plugins` line — **append** to the existing one.

**Add the admission config flag:**
```yaml
- --admission-control-config-file=/etc/kubernetes/admission/admission-config.yaml
```

**Add volumeMount:**
```yaml
    - mountPath: /etc/kubernetes/admission
      name: admission-config
      readOnly: true
```

**Add volume:**
```yaml
  - name: admission-config
    hostPath:
      path: /etc/kubernetes/admission
      type: DirectoryOrCreate
```

> **⚠ Don't wait!** Move to the next task. API server restarts in ~60s.

Click **Check** to validate.