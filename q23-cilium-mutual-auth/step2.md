## Step 2 – Apply the policy

```bash
kubectl apply -f - <<'YAML'
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
  # Rule 2: host (node) without mutual auth
  - fromEntities:
    - host
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
    authentication:
      mode: disabled
YAML
```

> **⚠ `authentication` is a SIBLING of `fromEndpoints`** — not nested inside it.

```bash
kubectl get ciliumnetworkpolicy -n mutual-auth
```

Click **Check** to validate.