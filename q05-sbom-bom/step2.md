## Step 2 – Fix the Deployment and generate report

Export and edit the Deployment:
```bash
kubectl get deploy alpine-app -n sbom-test -o yaml > /tmp/alpine-app.yaml
vim /tmp/alpine-app.yaml
```

Remove the container block using the vulnerable image (e.g., `alpine:3.16.1`).

Apply:
```bash
kubectl apply -f /tmp/alpine-app.yaml
kubectl rollout status deploy alpine-app -n sbom-test
```

Generate the SPDX report:
```bash
mkdir -p /opt/course

# Using trivy (most reliable):
trivy image --format spdx alpine:3.20.0 > /opt/course/sbom.spdx
# Verify
grep "SPDXVersion" /opt/course/sbom.spdx
```

Click **Check** to validate.