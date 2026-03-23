# CKS Lab – Container Immutability

**Domain:** Minimize Microservice Vulnerabilities (20%)
**Difficulty:** Easy | **Estimated time:** 5-6 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

Deployment `webapp` in namespace `hardening` runs with insecure defaults.

**Requirement 1 (Dockerfile):** Change `USER root` to `USER nobody`
_(file at `/opt/course/q18/Dockerfile`)_

**Requirement 2 (Deployment):** Set in the container securityContext:
```yaml
runAsUser: 65535
readOnlyRootFilesystem: true
privileged: false
allowPrivilegeEscalation: false
```

> The environment is being prepared...