## Lab Complete! 🎉

### PSS levels
| Standard | Blocks |
|----------|--------|
| `privileged` | Nothing |
| `baseline` | privileged, hostNetwork, hostPID, hostPath... |
| `restricted` | baseline + requires runAsNonRoot, seccomp, drop ALL caps |

### Key tips for the exam
- enforce = BLOCKS new pod creation
- Existing pods are NOT evicted — delete manually
- Error appears in ReplicaSet events, not kubectl apply output
- Don't apply restricted to kube-system!