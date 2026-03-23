## Step 1 – Find the vulnerable image

Check available images:
```bash
kubectl get deploy alpine-app -n sbom-test -o yaml | grep image
```

Scan each image for libcrypto3:
```bash
# Using trivy (always available)
trivy image --pkg-types os alpine:3.20.0 2>/dev/null | grep libcrypto3
trivy image --pkg-types os alpine:3.19.6 2>/dev/null | grep libcrypto3
trivy image --pkg-types os alpine:3.16.1 2>/dev/null | grep libcrypto3

# Or using bom (check first)
which bom && bom generate --image alpine:3.16.1 --format spdx 2>/dev/null | grep libcrypto3
```