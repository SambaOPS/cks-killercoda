# CKS Lab – AppArmor Profile Enforcement

**Domain:** System Hardening (10%)
**Difficulty:** Medium | **Estimated time:** 8-10 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

An AppArmor profile is available at `/opt/course/q13/profile` on `node01`.

**Requirement 1:** Load the AppArmor profile on `node01`.

**Requirement 2:** Create a Pod `apparmor-pod` in namespace `default` using `nginx:1.24`, enforced by the profile, pinned to `node01`.

> The environment is being prepared...