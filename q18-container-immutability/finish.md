## Lab Complete! 🎉

### SecurityContext reference
| Field | Level | Effect |
|-------|-------|--------|
| `runAsUser: 65535` | Pod or Container | UID 65535 = nobody |
| `readOnlyRootFilesystem: true` | Container only | Blocks all FS writes |
| `allowPrivilegeEscalation: false` | Container only | Blocks sudo/setuid |
| `privileged: false` | Container only | No host device access |

### Key tips for the exam
- `readOnlyRootFilesystem` and `allowPrivilegeEscalation` are container-level only
- If app needs /tmp: add an `emptyDir` volume mounted at `/tmp`
- UID 65535 = `nobody` (they're equivalent)