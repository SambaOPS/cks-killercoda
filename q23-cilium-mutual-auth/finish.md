## Lab Complete! 🎉

### Cilium auth modes
| Mode | Meaning |
|------|---------|
| `required` | Mutual TLS — both sides authenticate |
| `disabled` | No authentication — plain TCP |

### Key tips for the exam
- `authentication` is a sibling of `fromEndpoints`, not nested inside it
- Namespace label uses `k8s:io.kubernetes.pod.namespace` prefix
- `fromEntities: [host]` = the Kubernetes node itself
- Post-Oct 2024 exam may test this — practice the syntax