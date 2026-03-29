## Step 2 – Fix the Deployment (1 line) and apply

```bash
cat /opt/course/q06/deploy.yaml | grep readOnly
# → readOnlyRootFilesystem: false
```

Change **only** that line:
```bash
sed -i 's/readOnlyRootFilesystem: false/readOnlyRootFilesystem: true/' \
  /opt/course/q06/deploy.yaml
```

Apply:
```bash
kubectl apply -f /opt/course/q06/deploy.yaml
kubectl rollout status deploy static-app -n static-analysis
```

Click **Check** to validate.
