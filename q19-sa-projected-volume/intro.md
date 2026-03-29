# CKS Lab – ServiceAccount Token Security

**Domain:** Cluster Hardening (15%)
**Difficulty:** Medium | **Estimated time:** 8-10 min

---

## Exam-style Task

Deployment `api-app` in namespace `token-test` auto-mounts a ServiceAccount token unnecessarily.

**Requirement 1:** Disable automatic token mounting on ServiceAccount `api-sa`.

**Requirement 2:** Add a projected ServiceAccount token to the Deployment at `/var/run/secrets/tokens/api-token`, expiry 1 hour, read-only.

> Environment is being prepared...