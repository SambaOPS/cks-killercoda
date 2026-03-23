# CKS Lab – Audit Logging

**Domain:** Monitoring, Logging & Runtime Security (20%)
**Difficulty:** Hard | **Estimated time:** 12-15 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

The kube-apiserver has no audit logging configured.

**Requirement:** Create `/etc/kubernetes/audit/audit-policy.yaml` with:
- `secrets` in namespace `prod` → level `Metadata`
- `system:nodes` user group → level `RequestResponse`
- `configmaps` mutations → level `Request`
- Everything else → level `None`

Configure the API server to write logs to `/var/log/kubernetes/audit/audit.log` with `--audit-log-maxbackup=2`.

> ⚠ This lab edits the kube-apiserver manifest. The environment is being prepared...