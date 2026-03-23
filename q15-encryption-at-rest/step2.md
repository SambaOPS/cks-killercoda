## Step 2 – Configure API server

```bash
cp /etc/kubernetes/manifests/kube-apiserver.yaml{,.bak}
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

Add flag:
```yaml
- --encryption-provider-config=/etc/kubernetes/enc/enc.yaml
```

Add volumeMount:
```yaml
    - mountPath: /etc/kubernetes/enc
      name: enc-config
      readOnly: true
```

Add volume:
```yaml
  - name: enc-config
    hostPath:
      path: /etc/kubernetes/enc
      type: DirectoryOrCreate
```

Wait for restart, then re-encrypt existing secrets:
```bash
crictl ps | grep kube-apiserver   # wait for Running
kubectl get secrets --all-namespaces -o json | kubectl replace -f -
```