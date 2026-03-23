# CKS Lab – Docker Daemon Hardening

**Domain:** System Hardening (10%)
**Difficulty:** Medium | **Estimated time:** 8-10 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

The Docker daemon on `node01` has three security misconfigurations.

**Requirement 1:** Remove user `develop` from the `docker` group.

**Requirement 2:** Change ownership of `/var/run/docker.sock` to `root:root`.

**Requirement 3:** Edit `/lib/systemd/system/docker.service` to use a Unix socket instead of TCP (`-H tcp://0.0.0.0:2375`).

> The environment is being prepared...