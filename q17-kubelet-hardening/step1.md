## Step 1 – Inspect the kubelet configuration

```bash
ssh node01

# Find which config file kubelet uses
ps aux | grep kubelet | grep -o '\-\-config [^ ]*'
# → /var/lib/kubelet/config.yaml

# Inspect current values
grep -A3 "authentication:" /var/lib/kubelet/config.yaml
grep "mode:" /var/lib/kubelet/config.yaml
```

You should see `anonymous.enabled: true` and `mode: AlwaysAllow`.

> **⚠ Trap:** Always verify which config file is actually being used before editing.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi le kubelet est une cible majeure ?**
Son API (port 10250) permet d'exécuter des commandes dans n'importe quel pod du node (`/exec`), lire les logs, lister les pods. `anonymous.enabled: true` + `mode: AlwaysAllow` = **RCE non authentifiée sur tous les workloads du node**. C'est historiquement l'un des vecteurs d'attaque K8s les plus exploités (cryptominers scannant le 10250).

**Pourquoi vérifier quel fichier de config est utilisé ?**
Le kubelet peut être configuré par flags CLI, par fichier (`--config`), ou les deux (le flag gagne). Éditer un fichier que le process ne lit pas = fix fantôme, aucun symptôme. `ps aux | grep kubelet` d'abord, toujours — même réflexe que ton `grep enable-admission` avant édition.

📚 Ressources :
- https://kubernetes.io/docs/reference/access-authn-authz/kubelet-authn-authz/

</details>
