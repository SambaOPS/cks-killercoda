## Step 2 – Update Deployment and verify

```bash
kubectl set serviceaccount deployment api-server api-sa -n rbac-test
```

Verify permissions:
```bash
# Should return: yes
kubectl auth can-i get pods \
  --as=system:serviceaccount:rbac-test:api-sa -n rbac-test

# Should return: no
kubectl auth can-i delete pods \
  --as=system:serviceaccount:rbac-test:api-sa -n rbac-test

# Should return: no
kubectl auth can-i get secrets \
  --as=system:serviceaccount:rbac-test:api-sa -n rbac-test
```

Click **Check** to validate.