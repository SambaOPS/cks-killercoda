## Step 1 – Create SA, Role, and RoleBinding

```bash
# ServiceAccount with automount disabled
kubectl create sa api-sa -n rbac-test
kubectl patch sa api-sa -n rbac-test \
  -p '{"automountServiceAccountToken": false}'

# Role (apiGroups: [""] for core resources — NOT "core")
kubectl create role api-role \
  --verb=get,list,watch \
  --resource=pods,configmaps \
  -n rbac-test

# RoleBinding (namespace is MANDATORY in subjects)
kubectl create rolebinding api-rolebinding \
  --role=api-role \
  --serviceaccount=rbac-test:api-sa \
  -n rbac-test
```

> **⚠ Trap 1:** `apiGroups: [""]` (empty string) for pods/configmaps — not "core"
> **⚠ Trap 2:** `--serviceaccount=namespace:name` format is required

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi Role + RoleBinding et pas ClusterRole ?**
Le besoin est scoped à un namespace → l'objet de droit doit l'être aussi. Le blast radius d'un token volé = exactement `rbac-test`, rien d'autre. Cas hybride à connaître : **ClusterRole + RoleBinding** = définition réutilisable, effet namespacé — c'est le pattern des ClusterRoles standard (`view`, `edit`) bindés localement. Le piège inverse (Role référencé par un ClusterRoleBinding) est tout simplement invalide.

**Pourquoi `apiGroups: [""]` ?** Les ressources core (pods, configmaps, secrets, services) vivent dans le groupe *vide* — héritage historique d'avant les API groups. Écrire `"core"` ou `"v1"` crée un Role syntaxiquement valide qui ne matche RIEN : le `can-i` renverra `no` sans aucune erreur à l'apply. Failure mode silencieux n°1 du RBAC.

**verbs `["*"]` vs resources `["*"]`** : le second est pire — `get` sur toutes les ressources inclut `get secrets`, c'est-à-dire l'exfiltration de tous les credentials du namespace.

📚 Ressources :
- https://kubernetes.io/docs/reference/access-authn-authz/rbac/
- https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole

</details>
