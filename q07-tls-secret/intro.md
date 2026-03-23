# CKS Lab – TLS Secret

**Domain:** Minimize Microservice Vulnerabilities (20%)
**Difficulty:** Easy | **Estimated time:** 4-5 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

A Deployment `secure-app` in namespace `tls-test` is running without TLS.
Certificate and key files exist at `/opt/course/q07/`.

**Requirement 1:** Create a TLS Secret named `app-tls` in namespace `tls-test` using the provided cert/key files.

**Requirement 2:** Mount the secret into Deployment `secure-app` at `/etc/tls` (read-only).

> The environment is being prepared...