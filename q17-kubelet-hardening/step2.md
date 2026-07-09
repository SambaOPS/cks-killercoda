## Step 2 – Apply the fixes

Still on `node01`:

```bash
vim /var/lib/kubelet/config.yaml
```

Find and update:
```yaml
authentication:
  anonymous:
    enabled: false      # ← was true
  webhook:
    enabled: true
authorization:
  mode: Webhook         # ← was AlwaysAllow
```

Reload and restart:
```bash
systemctl daemon-reload
systemctl restart kubelet
systemctl status kubelet | grep "Active:"
```

Verify anonymous access is blocked:
```bash
curl -sk https://localhost:10250/pods
# → Unauthorized (expected — this is correct!)
```

Return to control plane:
```bash
exit
kubectl get node node01
# → must be Ready
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi `mode: Webhook` et pas juste couper l'anonyme ?**
Deux contrôles distincts : l'authentification (qui es-tu) et l'autorisation (as-tu le droit). Couper l'anonyme sans changer `AlwaysAllow` laisse **tout client authentifié** (n'importe quel cert du cluster CA) faire n'importe quoi. `Webhook` délègue chaque décision à l'API server via SubjectAccessReview → le RBAC central s'applique aussi au kubelet. Défense en profondeur : les deux couches, pas une.

**Pourquoi `Unauthorized` sur le curl = succès ?**
Le test négatif encore : la preuve du hardening est le refus. Un `200` avec la liste des pods = échec. Notez le port : 10250 est l'API authentifiée ; l'ancien 10255 (read-only, sans auth) doit lui être désactivé complètement.

📚 Ressources :
- https://kubernetes.io/docs/reference/access-authn-authz/kubelet-authn-authz/#kubelet-authorization

</details>
