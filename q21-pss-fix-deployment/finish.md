## Lab Complete! 🎉

### Restricted PSS — all 5 fields required simultaneously
| Field | Level | Value |
|-------|-------|-------|
| `seccompProfile.type` | Pod | `RuntimeDefault` ← most forgotten |
| `runAsNonRoot` | Pod | `true` |
| `allowPrivilegeEscalation` | Container | `false` |
| `capabilities.drop` | Container | `[ALL]` |
| `privileged` | Container | `false` |