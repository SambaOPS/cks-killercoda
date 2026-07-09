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


---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi cette condition ?**
- `evt.type = open` : on cible le syscall `open()` — c'est le point d'entrée obligatoire pour lire un device file. Intercepter au niveau syscall (eBPF) = impossible à contourner depuis le userspace du container.
- `container.id != host` : sans ce filtre, la règle matcherait aussi les process de l'hôte (kubelet, systemd) → bruit massif. En détection runtime, une règle bruyante est une règle morte (alert fatigue → normalisation de la déviance).
- `priority: WARNING` : la sévérité pilote le routage des alertes (Falcosidekick → Slack vs PagerDuty). À l'exam elle est imposée ; en prod c'est une décision d'astreinte.

**Pourquoi le format `output` est-il vérifié à l'exact ?**
Parce qu'en aval, un SIEM/Loki parse ce format. Un champ manquant casse le pipeline d'ingestion. Même logique que tes labels Prometheus : le format EST le contrat.

📚 Ressources :
- https://falco.org/docs/rules/basic-elements/ (anatomie d'une règle)
- https://falco.org/docs/reference/rules/supported-fields/

</details>
