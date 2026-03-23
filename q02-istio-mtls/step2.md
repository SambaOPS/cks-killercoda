## Step 2 – Apply strict mTLS

Create the PeerAuthentication resource:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: secured-app
spec:
  mtls:
    mode: STRICT
EOF
```

Verify:
```bash
kubectl get peerauthentication -n secured-app
```

> **⚠ Trap:** `kind: PeerAuthentication` — not `NetworkPolicy`.