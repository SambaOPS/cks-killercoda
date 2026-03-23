# CKS Lab – RBAC

**Domain:** Cluster Hardening (15%)
**Difficulty:** Medium | **Estimated time:** 8-10 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

Deployment `api-server` in namespace `rbac-test` uses the `default` ServiceAccount with excessive permissions.

**Requirement 1:** Create ServiceAccount `api-sa` with `automountServiceAccountToken: false`.

**Requirement 2:** Create Role `api-role` allowing only `get`, `list`, `watch` on `pods` and `configmaps`.

**Requirement 3:** Bind the role to `api-sa` via RoleBinding `api-rolebinding`.

**Requirement 4:** Update Deployment `api-server` to use `api-sa`.

**Requirement 5:** Verify `api-sa` cannot `delete` pods.

> The environment is being prepared...