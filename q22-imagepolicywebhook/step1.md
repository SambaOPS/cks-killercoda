## Step 1 – Inspect the provided config files

```bash
ls /etc/kubernetes/admission/
cat /etc/kubernetes/admission/admission-config.yaml
cat /etc/kubernetes/admission/kubeconfig.yaml
```

The `admission-config.yaml` should look like:
```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/kubernetes/admission/kubeconfig.yaml
      allowTTL: 50
      denyTTL: 50
      retryBackoff: 500
      defaultAllow: false   # ← MUST be false
```

If `defaultAllow` is `true`, change it:
```bash
grep "defaultAllow" /etc/kubernetes/admission/admission-config.yaml
# Change true → false if needed
```