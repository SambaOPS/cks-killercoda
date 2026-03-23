# CKS Lab – RuntimeClass gVisor

**Domain:** Minimize Microservice Vulnerabilities (20%)
**Difficulty:** Easy | **Estimated time:** 5-6 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

Deployment `untrusted-app` in namespace `team-purple` must run in a sandboxed container runtime.

**Requirement 1:** Create a `RuntimeClass` named `gvisor` with handler `runsc`.

**Requirement 2:** Update Deployment `untrusted-app` to use the RuntimeClass, pinned to `node01`.

**Requirement 3:** Verify gVisor is active via `dmesg`.

> ⏳ **Please wait 2-3 minutes** while the background script installs required tools.
> You can check progress with: `kubectl get pods -A`