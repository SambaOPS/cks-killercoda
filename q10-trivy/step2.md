## Step 2 – Scale down vulnerable Deployments and save output

Create the output directory:
```bash
mkdir -p /opt/course/q10
```

Save the scan result for `nginx:1.19.0`:
```bash
trivy image --severity CRITICAL nginx:1.19.0 > /opt/course/q10/result.txt
cat /opt/course/q10/result.txt
```

Scale down any Deployment with CRITICAL CVEs:
```bash
# Find which deployments use which images
kubectl get deploy -n prod -o wide

# Scale down (example — use actual results from your scan)
kubectl scale deploy web -n prod --replicas=0
```

Click **Check** to validate.