## Lab Complete! 🎉

### What is gVisor?
```
Normal container: App → syscalls → Kernel host (shared) → Hardware
gVisor container: App → Sentry (user-space kernel) → limited syscalls → Kernel host
```
gVisor reduces the attack surface if a container escape vulnerability is exploited.

### Key tips for the exam
- RuntimeClass = cluster-scoped (no namespace)
- `handler: runsc` — not "gvisor"
- `apiVersion: node.k8s.io/v1` (GA since 1.20)
- `nodeName` required — runsc only on specific nodes