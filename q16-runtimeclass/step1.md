## Step 1 – Create the RuntimeClass

```bash
cat <<EOF | kubectl apply -f -
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: gvisor
handler: runsc
EOF
```

Verify:
```bash
kubectl get runtimeclass gvisor
```

> **⚠ Traps:**
> - No `namespace` on RuntimeClass — it's cluster-scoped
> - `apiVersion: node.k8s.io/v1` (GA), NOT `v1beta1`
> - `handler: runsc` (the binary), NOT `handler: gvisor`