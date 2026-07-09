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

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi inspecter avant d'agir ?**
En prod comme à l'exam, on ne modifie jamais un système de détection runtime sans connaître son état initial. Falco charge ses règles dans un ordre précis : `falco_rules.yaml` (défaut, écrasé à chaque upgrade du package) puis `falco_rules.local.yaml` (vos overrides, persistants). Modifier le fichier par défaut = perdre vos règles au prochain `apt upgrade falco`. C'est exactement le même pattern que `sshd_config.d/` vs `sshd_config`, ou vos values Helm vs les defaults du chart.

**Pourquoi `/dev/mem` est-il critique ?**
`/dev/mem` expose la mémoire physique de l'hôte. Un container qui y accède peut lire les secrets de TOUS les process du node (tokens SA, clés TLS). C'est un indicateur classique de container escape.

📚 Ressources :
- https://falco.org/docs/rules/ (structure des fichiers de règles)
- https://falco.org/docs/rules/supported-fields/ (champs `evt.*`, `fd.*`, `container.*`)

</details>
