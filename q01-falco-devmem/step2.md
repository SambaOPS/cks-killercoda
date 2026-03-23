## Step 2 – Write the Falco rule

First, confirm Falco is running (try both service names):
```bash
systemctl is-active falco 2>/dev/null || \
systemctl is-active falco-modern-bpf 2>/dev/null || \
echo "Falco not running yet — wait 30s and retry"
```

Edit the custom rules file:
```bash
vim /etc/falco/falco_rules.local.yaml
```

Add the following rule (output format must be **exact**):

```yaml
- rule: Detect /dev/mem Access
  desc: Detect any container accessing /dev/mem
  condition: >
    evt.type = open and
    fd.name = /dev/mem and
    container.id != host
  output: >
    %evt.time,%container.id,%container.name,%user.name
  priority: WARNING
  tags: [container, filesystem, cks]
```

Restart Falco to load the rule:
```bash
systemctl restart falco 2>/dev/null || systemctl restart falco-modern-bpf 2>/dev/null
journalctl -u falco --no-pager -n 20 2>/dev/null || \
journalctl -u falco-modern-bpf --no-pager -n 20
```

> **⚠ Trap:** Never edit `falco_rules.yaml`. Always use `falco_rules.local.yaml`.
