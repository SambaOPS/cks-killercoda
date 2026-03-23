## Step 2 – Apply all required securityContext fields

Edit `/tmp/violating-app.yaml`:

```bash
vim /tmp/violating-app.yaml
```

Add to `spec.template.spec` (pod level):
```yaml
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        seccompProfile:
          type: RuntimeDefault
```

Add to `spec.template.spec.containers[0].securityContext` (container level):
```yaml
        securityContext:
          allowPrivilegeEscalation: false
          privileged: false
          readOnlyRootFilesystem: true
          capabilities:
            drop:
            - ALL
```

Apply:
```bash
kubectl apply -f /tmp/violating-app.yaml
kubectl rollout status deploy violating-app -n pss-fix
kubectl get pods -n pss-fix
# Pods should now be Running
```

> **⚠ The most forgotten field:** `seccompProfile.type: RuntimeDefault`
> Without it, `restricted` enforcement blocks the pod!

Click **Check** to validate.