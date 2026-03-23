## Lab Complete! 🎉

### Why this matters
With `anonymous.enabled: true` + `AlwaysAllow`, anyone on the network can:
- Query `/pods` to enumerate all pods on the node
- Execute commands in containers via `/exec`
- Read secrets from pod processes

### Key tips for the exam
- Always find the correct config file: `ps aux | grep kubelet | grep config`
- `daemon-reload` before `restart kubelet`
- Verify node is still `Ready` after changes
- Check with kube-bench: IDs `4.2.1` and `4.2.2`