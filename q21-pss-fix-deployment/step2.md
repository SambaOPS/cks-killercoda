## Step 2 – Apply all required fields

```bash
vim /tmp/fix.yaml
```

Add to `spec.template.spec` (pod level):
```yaml
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        seccompProfile:
          type: RuntimeDefault
```

Add to `spec.template.spec.containers[0].securityContext`:
```yaml
        securityContext:
          allowPrivilegeEscalation: false
          privileged: false
          readOnlyRootFilesystem: true
          capabilities:
            drop:
            - ALL
```

```bash
kubectl apply -f /tmp/fix.yaml
kubectl rollout status deploy violating-app -n pss-fix
kubectl get pods -n pss-fix
# Should be Running ✅
```

Click **Check** to validate.