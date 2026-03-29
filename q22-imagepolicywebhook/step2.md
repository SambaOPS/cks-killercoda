## Step 2 – Edit the kube-apiserver manifest

```bash
cp /etc/kubernetes/manifests/kube-apiserver.yaml{,.bak}
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

**1. APPEND** `ImagePolicyWebhook` to the existing `--enable-admission-plugins` flag:
```yaml
- --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook
```

**2. Add** the admission config flag:
```yaml
- --admission-control-config-file=/etc/kubernetes/admission/admission-config.yaml
```

**3. Add** volumeMount:
```yaml
    - mountPath: /etc/kubernetes/admission
      name: admission-config
      readOnly: true
```

**4. Add** volume:
```yaml
  - name: admission-config
    hostPath:
      path: /etc/kubernetes/admission
      type: DirectoryOrCreate
```

> ⚠️ Do NOT create a second `--enable-admission-plugins` line — append to the existing one.

Click **Check** to validate.