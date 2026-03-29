## Step 1 – Key Cilium syntax vs standard NetworkPolicy

| Standard NetworkPolicy | CiliumNetworkPolicy |
|------------------------|---------------------|
| `podSelector` | `endpointSelector` |
| `from.podSelector` | `fromEndpoints[].matchLabels` |
| `namespaceSelector` | `k8s:io.kubernetes.pod.namespace` label |
| N/A | `authentication.mode: required` |
| N/A | `fromEntities: [host]` |

```bash
kubectl get pods -n kube-system | grep cilium
kubectl get crd | grep cilium
```