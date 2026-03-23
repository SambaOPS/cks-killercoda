## Step 2 – Create the pod with AppArmor enforcement

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: apparmor-pod
  namespace: default
spec:
  nodeName: node01
  securityContext:
    appArmorProfile:
      type: Localhost
      localhostProfile: cks-nginx-deny-write
  containers:
  - name: nginx
    image: nginx:1.24
EOF
```

Verify:
```bash
kubectl get pod apparmor-pod
kubectl describe pod apparmor-pod | grep -i apparmor
```

Test enforcement (the profile denies writes):
```bash
kubectl exec apparmor-pod -- touch /tmp/test-write 2>&1
# → Permission denied ✅ (profile is working)
```

Click **Check** to validate.