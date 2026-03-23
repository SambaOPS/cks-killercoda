## Step 1 – Key Cilium syntax differences

| Standard NetworkPolicy | CiliumNetworkPolicy |
|----------------------|---------------------|
| `podSelector` | `endpointSelector` |
| `from.podSelector` | `fromEndpoints` |
| `from.namespaceSelector` | Namespace label via `k8s:io.kubernetes.pod.namespace` |
| N/A | `authentication.mode: required` |
| N/A | `fromEntities: [host]` |

Verify Cilium is running:
```bash
kubectl get pods -n kube-system | grep cilium
```