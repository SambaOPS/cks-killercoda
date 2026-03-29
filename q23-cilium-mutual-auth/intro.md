# CKS Lab – Cilium Mutual Authentication

**Domain:** Cluster Setup (15%)
**Difficulty:** Hard | **Estimated time:** 12-15 min

> ⏳ **Please wait 3-4 minutes** — Cilium is being verified in the background.
> Check: `kubectl get pods -n kube-system | grep cilium`

---

## Exam-style Task

Namespace `mutual-auth` has `frontend` and `backend` Deployments.

**Requirement 1:** Allow `app=frontend` pods (namespace `frontend-ns`) to access `backend` — **mutual authentication required**.

**Requirement 2:** Allow the **host** (node) to access `backend` on port 8080 — **without mutual auth**.

**Requirement 3:** Deny all other ingress to `backend`.