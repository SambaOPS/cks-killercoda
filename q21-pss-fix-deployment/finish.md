## Lab Complete! 🎉

### The restricted PSS checklist (ALL required)
| Field | Level | Value |
|-------|-------|-------|
| `seccompProfile.type` | Pod | `RuntimeDefault` |
| `runAsNonRoot` | Pod | `true` |
| `allowPrivilegeEscalation` | Container | `false` |
| `capabilities.drop` | Container | `[ALL]` |
| `privileged` | Container | `false` |

### Key tips for the exam
- `seccompProfile` is the most forgotten field
- Pod-level vs container-level matters — check the docs
- Verify with `kubectl apply --dry-run=server` before applying