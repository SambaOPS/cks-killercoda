# CKS Lab – Ingress TLS

**Domain:** Cluster Setup (15%)
**Difficulty:** Easy | **Estimated time:** 5-6 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

A TLS Secret `web-tls` and backend Service `web-svc` already exist in namespace `web`.

**Requirement 1:** Create Ingress `web-ingress` routing `web.example.com` to `web-svc:80`.

**Requirement 2:** Terminate TLS using secret `web-tls`.

**Requirement 3:** Add the annotation to redirect all HTTP traffic to HTTPS.

> The environment is being prepared...