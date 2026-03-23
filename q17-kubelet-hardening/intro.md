# CKS Lab – Kubelet Hardening

**Domain:** Cluster Hardening (15%)
**Difficulty:** Medium | **Estimated time:** 8-10 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

The kubelet on `node01` is running with an insecure configuration.

**Requirement 1:** Disable anonymous authentication: `authentication.anonymous.enabled: false`

**Requirement 2:** Enable Webhook authorization: `authorization.mode: Webhook`

> The environment is being prepared...