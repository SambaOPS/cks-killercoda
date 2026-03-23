# CKS Lab – ServiceAccount Token Security

**Domain:** Cluster Hardening (15%)
**Difficulty:** Medium | **Estimated time:** 8-10 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

Deployment `api-app` in namespace `token-test` auto-mounts a ServiceAccount token unnecessarily.

**Requirement 1:** Disable automatic token mounting on ServiceAccount `api-sa`.

**Requirement 2:** Add a projected ServiceAccount token to the Deployment at `/var/run/secrets/tokens/api-token` with 1 hour expiry (read-only).

> The environment is being prepared...