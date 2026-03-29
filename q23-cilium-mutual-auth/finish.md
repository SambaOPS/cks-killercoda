## Lab Complete! 🎉

### Cilium authentication modes
- `required` = mutual TLS — both sides authenticate with Cilium identity certs
- `disabled` = plain TCP — no authentication

### Common mistakes
- `authentication` must be at the **same level** as `fromEndpoints` (sibling, not child)
- Namespace label uses `k8s:` prefix: `k8s:io.kubernetes.pod.namespace`
- `fromEntities: [host]` = the Kubernetes node itself (kubelet, hostNetwork processes)