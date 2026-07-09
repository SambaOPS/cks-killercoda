## Step 1 – Diagnose

```bash
kubectl get pods -n pss-fix
# No pods running

kubectl get deploy violating-app -n pss-fix -o yaml > /tmp/fix.yaml

# See ALL violations at once
kubectl apply -f /tmp/fix.yaml --dry-run=server 2>&1
```

The `restricted` standard requires ALL of:
- `allowPrivilegeEscalation: false`
- `runAsNonRoot: true`
- `capabilities.drop: [ALL]`
- `seccompProfile.type: RuntimeDefault`  ← most often forgotten
- `privileged: false`

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi `--dry-run=server` est le bon réflexe diagnostic ?**
`--dry-run=client` valide seulement le schéma YAML localement. `=server` envoie l'objet à l'API server qui exécute **toute la chaîne d'admission** (PSA, Kyverno, webhooks) sans persister — vous obtenez la liste COMPLÈTE des violations en une commande, au lieu de corriger-appliquer-échouer en boucle. Gain de temps massif à l'exam.

**Pourquoi les pods sont absents mais le Deployment "healthy" ?**
PSA rejette les **pods** à l'admission, pas le Deployment (qui n'est qu'un template). Le ReplicaSet essaie de créer les pods, échoue silencieusement — symptôme : `READY 0/1`, aucun event sur le Deployment lui-même. Diagnostic : `kubectl describe rs` ou `kubectl get events -n pss-fix`. Même logique que tes generate policies Kyverno : l'admission agit sur l'objet final, pas sur son parent.

📚 Ressources :
- https://kubernetes.io/docs/concepts/security/pod-security-standards/ (tableau restricted — À CONNAÎTRE)
- https://kubernetes.io/docs/concepts/security/pod-security-admission/

</details>
