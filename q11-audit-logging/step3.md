## Step 3 – Verify

Wait for the API server to restart (~60s):
```bash
crictl ps | grep kube-apiserver
kubectl get nodes
```

Check the audit log is being written:
```bash
ls -la /var/log/kubernetes/audit/
tail -5 /var/log/kubernetes/audit/audit.log | python3 -m json.tool | head -20
```

Generate a test event:
```bash
kubectl get secret -n prod 2>/dev/null || true
tail -3 /var/log/kubernetes/audit/audit.log | grep -i secret
```

Click **Check** to validate.