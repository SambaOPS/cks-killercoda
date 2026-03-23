## Step 1 – Create the audit policy

```bash
mkdir -p /etc/kubernetes/audit
mkdir -p /var/log/kubernetes/audit

cat > /etc/kubernetes/audit/audit-policy.yaml <<'EOF'
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
  resources:
  - group: ""
    resources: ["secrets"]
  namespaces: ["prod"]
- level: RequestResponse
  userGroups: ["system:nodes"]
- level: Request
  verbs: ["create", "update", "patch", "delete"]
  resources:
  - group: ""
    resources: ["configmaps"]
- level: None
EOF
```

> **⚠ First match wins** — `None` must be **last**.