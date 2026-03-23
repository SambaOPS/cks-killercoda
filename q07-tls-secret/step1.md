## Step 1 – Create the TLS Secret

```bash
ls /opt/course/q07/
# tls.crt  tls.key

kubectl create secret tls app-tls \
  --cert=/opt/course/q07/tls.crt \
  --key=/opt/course/q07/tls.key \
  -n tls-test

kubectl get secret app-tls -n tls-test
# Type should be: kubernetes.io/tls
```

> **⚠ Trap:** Use `--cert` and `--key` flags — NOT `--from-file`.