# CKS Lab – Secrets Encryption at Rest

**Domain:** Minimize Microservice Vulnerabilities (20%)
**Difficulty:** Hard | **Estimated time:** 12-15 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

Kubernetes secrets are currently stored in plaintext in etcd.

**Requirement 1:** Create an EncryptionConfiguration at `/etc/kubernetes/enc/enc.yaml` using `aescbc`.

**Requirement 2:** Configure the kube-apiserver to use it.

**Requirement 3:** Re-encrypt all existing secrets.

**Requirement 4:** Verify a secret is encrypted in etcd.

> The environment is being prepared...