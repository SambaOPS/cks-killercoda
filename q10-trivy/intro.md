# CKS Lab – Trivy Image Scanning

**Domain:** Supply Chain Security (20%)
**Difficulty:** Medium | **Estimated time:** 6-8 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

Multiple pods are running in namespace `prod` with potentially vulnerable images.

**Requirement 1:** Scan all images in namespace `prod` for **CRITICAL** vulnerabilities.

**Requirement 2:** Scale down to 0 any Deployment whose image has CRITICAL CVEs.

**Requirement 3:** Save the scan of `nginx:1.19.0` to `/opt/course/q10/result.txt`.

> The environment is being prepared...