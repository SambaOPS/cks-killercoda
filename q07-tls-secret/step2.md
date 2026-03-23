## Step 2 – Mount the secret

```bash
kubectl get deploy secure-app -n tls-test -o yaml > /tmp/secure-app.yaml
vim /tmp/secure-app.yaml
```

Add to `spec.template.spec.containers[0]`:
```yaml
        volumeMounts:
        - name: tls-secret
          mountPath: /etc/tls
          readOnly: true
```

Add to `spec.template.spec`:
```yaml
      volumes:
      - name: tls-secret
        secret:
          secretName: app-tls
```

Apply and verify:
```bash
kubectl apply -f /tmp/secure-app.yaml
kubectl rollout status deploy secure-app -n tls-test
kubectl exec -n tls-test deploy/secure-app -- ls /etc/tls
# → tls.crt  tls.key
```

Click **Check** to validate.