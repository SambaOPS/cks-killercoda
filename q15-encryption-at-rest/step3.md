## Step 3 – Verify in etcd

Create a test secret:
```bash
kubectl create secret generic enc-test \
  --from-literal=password=mysupersecret -n default
```

Read directly from etcd:
```bash
ETCDCTL_API=3 etcdctl \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  get /registry/secrets/default/enc-test | hexdump -C | head -3
```

**Expected:** First bytes should be `k8s:enc:aescbc:v1:key1` — NOT plaintext.

Click **Check** to validate.