## Step 2 – Apply the policy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: backend-ingress
  namespace: mutual-auth
spec:
  endpointSelector:
    matchLabels:
      app: backend
  ingress:
  # Rule 1: frontend pods with mutual TLS
  - fromEndpoints:
    - matchLabels:
        app: frontend
        k8s:io.kubernetes.pod.namespace: frontend-ns
    authentication:
      mode: required
  # Rule 2: host access without mutual TLS
  - fromEntities:
    - host
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
    authentication:
      mode: disabled
EOF
```

> **⚠ Trap:** `authentication` is a **sibling** of `fromEndpoints`, NOT nested inside it.

Verify:
```bash
kubectl get ciliumnetworkpolicy -n mutual-auth
```

Click **Check** to validate.