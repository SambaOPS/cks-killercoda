## Step 1 – List and scan

List all unique images:
```bash
kubectl get pods -n prod \
  -o jsonpath='{range .items[*]}{range .spec.containers[*]}{.image}{"\n"}{end}{end}' | sort -u
```

Check if Trivy is available:
```bash
which trivy || ssh node01 which trivy
```

Scan each image:
```bash
trivy image --severity CRITICAL nginx:1.19.0
trivy image --severity CRITICAL redis:6.0.5
trivy image --severity CRITICAL alpine:3.12
```

> **⚠ Trap:** Trivy may only be installed on node01 — check both!