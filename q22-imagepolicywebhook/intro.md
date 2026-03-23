# CKS Lab – ImagePolicyWebhook

**Domain:** Supply Chain Security (20%)
**Difficulty:** Hard | **Estimated time:** 12-15 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

Configure the API server to validate container images via a webhook.

**Requirement 1:** Enable `ImagePolicyWebhook` in the API server admission plugins.

**Requirement 2:** Set `defaultAllow: false` so images are **denied** when the backend is unreachable.

**Requirement 3:** Use the provided AdmissionConfiguration at `/etc/kubernetes/admission/`.

> The environment is being prepared...