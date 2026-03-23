## Step 1 – Inspect the environment

Check the running pods and Falco status.

```bash
kubectl get pods -n production
```

You should see `nvidia`, `cpu`, and `ollama` pods running.

```bash
systemctl status falco
ls /etc/falco/
```

Notice:
- `/etc/falco/falco_rules.yaml` — default rules (do **not** modify)
- `/etc/falco/falco_rules.local.yaml` — your custom rules file

```bash
cat /etc/falco/falco_rules.local.yaml
```