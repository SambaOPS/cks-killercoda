## Step 2 – Fix the Deployment

```bash
kubectl get deploy webapp -n hardening -o yaml > /tmp/webapp.yaml
vim /tmp/webapp.yaml
```

Find the container spec and set/add the securityContext:

```yaml
        securityContext:
          runAsUser: 65535
          readOnlyRootFilesystem: true
          privileged: false
          allowPrivilegeEscalation: false
```

Apply:
```bash
kubectl apply -f /tmp/webapp.yaml
kubectl rollout status deploy webapp -n hardening
```

Verify:
```bash
# Should fail with Read-only file system
kubectl exec -n hardening deploy/webapp -- touch /test 2>&1
# → touch: cannot touch '/test': Read-only file system ✅

# Should show uid=65535
kubectl exec -n hardening deploy/webapp -- id
# → uid=65535(nobody) ✅
```

Click **Check** to validate.