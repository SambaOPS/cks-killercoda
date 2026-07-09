## Step 2 – Update Deployment and verify

```bash
kubectl set serviceaccount deployment api-server api-sa -n rbac-test
```

Verify permissions:
```bash
# Should return: yes
kubectl auth can-i get pods \
  --as=system:serviceaccount:rbac-test:api-sa -n rbac-test

# Should return: no
kubectl auth can-i delete pods \
  --as=system:serviceaccount:rbac-test:api-sa -n rbac-test

# Should return: no
kubectl auth can-i get secrets \
  --as=system:serviceaccount:rbac-test:api-sa -n rbac-test
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi tester les trois cas — y compris les refus ?**
Un test RBAC ne vaut que s'il vérifie les deux faces : ce qui DOIT passer (`get pods` → yes) et ce qui DOIT être refusé (`delete pods`, `get secrets` → no). Tester seulement le positif laisse passer un Role trop large — or "trop de droits" ne produit aucun symptôme fonctionnel, c'est invisible jusqu'à l'incident. C'est l'équivalent RBAC de tes tests d'admission Kyverno.

**`kubectl auth can-i --as=`** = impersonation : l'API server évalue la requête avec l'identité fournie, sans avoir besoin du token du SA. Format `system:serviceaccount:<ns>:<name>` à connaître par cœur. En prod, `kubectl auth can-i --list --as=...` te donne l'inventaire complet des droits d'un compte — parfait pour auditer, par exemple, le compte userpass Vault de jbo dont la policy admin est trop large : même problème, autre système.

📚 Ressources :
- https://kubernetes.io/docs/reference/access-authn-authz/authorization/#checking-api-access

</details>
