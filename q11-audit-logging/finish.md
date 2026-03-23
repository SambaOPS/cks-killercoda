## Lab Complete! 🎉

### The universal kube-apiserver pattern
Every question that adds a file to the API server needs:
1. The flag pointing to the file
2. A `volumeMount` for the file/directory
3. A `volume` with `hostPath`

### Key tips for the exam
- **First match wins** — `None` must be last in the policy
- Two volume mounts: policy (`type: File`) + log dir (`type: DirectoryOrCreate`)
- **Never wait for API server restart** — flag the question, move on, come back
- Always backup: `cp kube-apiserver.yaml{,.bak}`