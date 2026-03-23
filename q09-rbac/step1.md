## Step 1 – Create SA, Role, and RoleBinding

```bash
# ServiceAccount with automount disabled
kubectl create sa api-sa -n rbac-test
kubectl patch sa api-sa -n rbac-test \
  -p '{"automountServiceAccountToken": false}'

# Role (apiGroups: [""] for core resources — NOT "core")
kubectl create role api-role \
  --verb=get,list,watch \
  --resource=pods,configmaps \
  -n rbac-test

# RoleBinding (namespace is MANDATORY in subjects)
kubectl create rolebinding api-rolebinding \
  --role=api-role \
  --serviceaccount=rbac-test:api-sa \
  -n rbac-test
```

> **⚠ Trap 1:** `apiGroups: [""]` (empty string) for pods/configmaps — not "core"
> **⚠ Trap 2:** `--serviceaccount=namespace:name` format is required