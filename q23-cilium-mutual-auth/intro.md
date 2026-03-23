# CKS Lab – Cilium Mutual Authentication

**Domain:** Cluster Setup (15%)
**Difficulty:** Hard | **Estimated time:** 12-15 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

Namespace `mutual-auth` has `frontend` and `backend` Deployments.

**Requirement 1:** Allow pods with `app=frontend` (from namespace `frontend-ns`) to access `backend` — **with mutual authentication**.

**Requirement 2:** Allow the host (node) to access `backend` on port 8080 — **without mutual authentication**.

**Requirement 3:** Deny all other ingress to `backend`.

> The environment is being prepared...