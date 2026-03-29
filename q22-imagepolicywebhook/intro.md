# CKS Lab – ImagePolicyWebhook

**Domain:** Supply Chain Security (20%)
**Difficulty:** Hard | **Estimated time:** 12-15 min

---

## Exam-style Task

Configure the API server to validate images via a webhook before allowing pod creation.

**Requirement 1:** Enable `ImagePolicyWebhook` in admission plugins.

**Requirement 2:** Use the provided AdmissionConfiguration at `/etc/kubernetes/admission/`.

**Requirement 3:** `defaultAllow: false` — deny images when backend is unreachable.

> Environment is being prepared...