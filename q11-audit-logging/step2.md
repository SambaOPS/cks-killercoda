## Step 2 – Edit the kube-apiserver manifest

**Always backup first:**
```bash
cp /etc/kubernetes/manifests/kube-apiserver.yaml \
   /etc/kubernetes/manifests/kube-apiserver.yaml.bak
```

Edit the manifest:
```bash
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

Add these 4 flags to `spec.containers[0].command`:
```yaml
    - --audit-policy-file=/etc/kubernetes/audit/audit-policy.yaml
    - --audit-log-path=/var/log/kubernetes/audit/audit.log
    - --audit-log-maxbackup=2
    - --audit-log-maxage=30
```

Add to `spec.containers[0].volumeMounts`:
```yaml
    - mountPath: /etc/kubernetes/audit/audit-policy.yaml
      name: audit-policy
      readOnly: true
    - mountPath: /var/log/kubernetes/audit
      name: audit-log
      readOnly: false
```

Add to `spec.volumes`:
```yaml
  - name: audit-policy
    hostPath:
      path: /etc/kubernetes/audit/audit-policy.yaml
      type: File
  - name: audit-log
    hostPath:
      path: /var/log/kubernetes/audit
      type: DirectoryOrCreate
```

> **⚠ Don't wait!** Save the file and move to the next step. The API server restarts automatically in ~60s.