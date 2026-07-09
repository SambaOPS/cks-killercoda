## Step 1 – Disable automount on the ServiceAccount

```bash
kubectl patch serviceaccount api-sa -n token-test \
  -p '{"automountServiceAccountToken": false}'

kubectl get sa api-sa -n token-test -o yaml | grep automount
# → automountServiceAccountToken: false
```

> **⚠ Two levels:** The pod spec overrides the SA setting. Disable both for defense-in-depth.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi désactiver l'automount ?**
Par défaut, chaque pod reçoit un token SA monté dans `/var/run/secrets/kubernetes.io/serviceaccount/` — même s'il ne parle jamais à l'API. Un attaquant qui obtient une RCE dans le container récupère ce token gratuitement et pivote vers l'API server avec les droits du SA. Least privilege : **pas besoin de l'API = pas de token du tout.**

**Pourquoi les deux niveaux (SA + pod spec) ?**
Le champ du pod spec **override** celui du SA. Défense en profondeur : le SA à `false` protège les futurs pods par défaut ; le pod spec à `false` verrouille explicitement celui-ci. Chez toi, c'est un audit à faire : tes workloads Online Boutique montent-ils des tokens dont ils ne se servent pas ? (Kyverno a une policy toute prête pour le vérifier.)

📚 Ressources :
- https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#opt-out-of-api-credential-automounting
- https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/

</details>
