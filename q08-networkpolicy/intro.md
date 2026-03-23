# CKS Lab – NetworkPolicy

**Domain:** Cluster Setup (15%)
**Difficulty:** Hard | **Estimated time:** 10-12 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

Two namespaces exist: `frontend` and `backend`.

**Requirement 1:** Create a default-deny-all policy (Ingress + Egress) in namespace `backend`.

**Requirement 2:** Allow **only** pods with label `app=frontend` in namespace `frontend` to reach pods `app=api` in `backend` on port 8080.

**Requirement 3:** Allow DNS egress (port 53 UDP+TCP) from all pods in `backend`.

> The environment is being prepared...