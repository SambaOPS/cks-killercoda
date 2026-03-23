# CKS Lab – SBOM with bom/trivy

**Domain:** Supply Chain Security (20%)
**Difficulty:** Hard | **Estimated time:** 12-15 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

Deployment `alpine-app` in namespace `sbom-test` runs 3 containers with different Alpine versions.

**Requirement 1:** Identify which container has `libcrypto3` version `3.1.x` (vulnerable).

**Requirement 2:** Remove that container from the Deployment and redeploy.

**Requirement 3:** Generate an SPDX SBOM report for the remaining images at `/opt/course/sbom.spdx`.

> The environment is being prepared...