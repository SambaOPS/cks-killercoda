## Step 2 – Verify blocking

Try to create a violating pod:
```bash
kubectl run test-priv -n team-red \
  --image=nginx --restart=Never \
  --overrides='{"spec":{"containers":[{"name":"test","image":"nginx","securityContext":{"privileged":true}}]}}'
```

Expected output:
```
Error from server (Forbidden): pods "test-priv" is forbidden:
violates PodSecurity "baseline:latest": privileged
```

Check that Deployments create but pods don't run (error is in ReplicaSet events):
```bash
kubectl describe rs -n team-red 2>/dev/null | grep Warning || echo "No ReplicaSets"
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi le test négatif est la vraie validation ?**
Un label posé ≠ une policy active (typo dans le label = PSA ignore silencieusement — `pod-security.kubernetes.io/enforce` doit être exact). Seul un rejet effectif `Error from server (Forbidden)... violates PodSecurity` prouve le fonctionnement. Toujours tester le chemin d'échec.

**Pourquoi chercher l'erreur dans les events du ReplicaSet ?**
PSA rejette la création du *pod*, pas du Deployment. Le Deployment reste vert, le RS accumule des `Warning FailedCreate` — c'est le seul endroit où l'erreur apparaît. Pattern de debug à mémoriser : quand un Deployment n'a pas de pods sans raison visible, `kubectl describe rs` ou `kubectl get events`, pas `describe deploy`.

📚 Ressources :
- https://kubernetes.io/docs/concepts/security/pod-security-standards/

</details>
