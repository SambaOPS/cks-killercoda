## Step 2 – Write the Falco rule

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
systemctl restart falco
systemctl status falco
journalctl -fu falco --no-pager | head -20
```

> **⚠ Trap:** Never edit `falco_rules.yaml`. Always use `falco_rules.local.yaml`.