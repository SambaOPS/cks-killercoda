## Lab Complete! 🎉

### Key tips for the exam
- `apiGroups: [""]` (empty) for core resources — `"core"` is INVALID
- `namespace` is mandatory in RoleBinding subjects for ServiceAccounts
- `kubectl auth can-i` with `--as=system:serviceaccount:ns:name` for verification
- `kubectl auth can-i --list --as=...` shows all permissions