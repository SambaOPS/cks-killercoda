## Step 2 – Add projected token to Deployment

```bash
kubectl get deploy api-app -n token-test -o yaml > /tmp/api-app.yaml
vim /tmp/api-app.yaml
```

Add to `spec.template.spec`:
```yaml
      automountServiceAccountToken: false
```

Add to `containers[0].volumeMounts`:
```yaml
        - name: api-token
          mountPath: /var/run/secrets/tokens
          readOnly: true
```

Add to `spec.volumes`:
```yaml
      - name: api-token
        projected:
          sources:
          - serviceAccountToken:
              path: api-token
              expirationSeconds: 3600
```

```bash
kubectl apply -f /tmp/api-app.yaml
kubectl exec deploy/api-app -n token-test -- ls /var/run/secrets/tokens/
# → api-token ✅
```

Click **Check** to validate.