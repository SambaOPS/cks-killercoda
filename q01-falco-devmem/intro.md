# CKS Lab – Falco Runtime Security

**Domain:** Monitoring, Logging & Runtime Security (20%)
**Difficulty:** Medium | **Estimated time:** 8-10 min
**Based on:** Real CKS exam reports (2025)

---

## Exam-style Task

You have a cluster running several pods in namespace `production`.
Three pods — `nvidia`, `cpu`, and `ollama` — are suspected of accessing `/dev/mem`, a sensitive host device.

**Requirement 1:** Create a custom Falco rule detecting container access to `/dev/mem`.
Output format must be exactly:
```
%evt.time,%container.id,%container.name,%user.name
```

**Requirement 2:** Scale down the three offending Deployments to **0 replicas**.

> ⏳ **Please wait 2-3 minutes** while the background script installs required tools.
> You can check progress with: `kubectl get pods -A`