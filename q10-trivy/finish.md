## Lab Complete! 🎉

### Key tips for the exam
- `trivy image --severity HIGH,CRITICAL <image>` for precise filtering
- Trivy may only be on node01 — always check with `which trivy`
- Also check `initContainers` for vulnerable images
- `mkdir -p` before redirecting output to a file