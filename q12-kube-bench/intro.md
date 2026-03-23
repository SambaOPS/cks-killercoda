# CKS Lab – kube-bench CIS Remediation

**Domain:** Cluster Setup + Cluster Hardening (30%)
**Difficulty:** Medium | **Estimated time:** 10-12 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

Several CIS benchmark checks are failing on the control plane.

**Fix the following failures:**
- `1.2.1` — anonymous auth must be disabled
- `1.2.12` — profiling must be disabled
- `1.2.16` — authorization mode must be `Node,RBAC`
- `1.2.19` — insecure port must be 0
- `1.1.12` — etcd data dir owned by `etcd:etcd`
- `4.1.9` — kubelet config permissions must be `600`

> The environment is being prepared with intentional misconfigurations...