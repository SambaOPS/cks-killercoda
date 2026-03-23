## Step 2 – Add projected token to Deployment

```bash
kubectl get deploy api-app -n token-test -o yaml > /tmp/api-app.yaml
vim /tmp/api-app.yaml
```

Add to `spec.template.spec`:
```yaml
      automountServiceAccountToken: false
```

Add to `spec.template.spec.containers[0].volumeMounts`:
```yaml
        - name: api-token
          mountPath: /var/run/secrets/tokens
          readOnly: true
```

Add to `spec.template.spec.volumes`:
```yaml
      - name: api-token
        projected:
          sources:
          - serviceAccountToken:
              path: api-token
              expirationSeconds: 3600
```

Apply and verify:
```bash
kubectl apply -f /tmp/api-app.yaml
kubectl rollout status deploy api-app -n token-test
kubectl exec -n token-test deploy/api-app -- ls /var/run/secrets/tokens/
# → api-token ✅
```

Click **Check** to validate.