# CKS Lab – Istio mTLS

**Domain:** Minimize Microservice Vulnerabilities (20%)
**Difficulty:** Easy | **Estimated time:** 4-5 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

Namespace `secured-app` contains Deployment `web-app`. Istio is installed.

**Requirement 1:** Enable automatic sidecar injection on namespace `secured-app`.

**Requirement 2:** Apply a PeerAuthentication policy enforcing **strict mTLS** for all workloads in `secured-app`.

**Requirement 3:** Restart the Deployment so existing pods get the sidecar injected.

> The environment is being prepared...