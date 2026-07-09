## Step 1 – Create the audit policy

```bash
mkdir -p /etc/kubernetes/audit
mkdir -p /var/log/kubernetes/audit

cat > /etc/kubernetes/audit/audit-policy.yaml <<'EOF'
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
  resources:
  - group: ""
    resources: ["secrets"]
  namespaces: ["prod"]
- level: RequestResponse
  userGroups: ["system:nodes"]
- level: Request
  verbs: ["create", "update", "patch", "delete"]
  resources:
  - group: ""
    resources: ["configmaps"]
- level: None
EOF
```

> **⚠ First match wins** — `None` must be **last**.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi "first match wins" structure toute la policy ?**
L'API server évalue les règles séquentiellement et s'arrête au premier match. La policy se lit donc du plus spécifique au plus général, avec le catch-all (`level: None` ou `Metadata`) en dernier. Inverser l'ordre = la règle générale avale tout et vos règles fines ne matchent jamais. Même modèle mental que les règles firewall ou les `location` nginx.

**Pourquoi `Metadata` pour les secrets et pas `RequestResponse` ?**
`RequestResponse` loggerait le **contenu des secrets en clair dans le fichier d'audit** — vous créeriez une fuite en voulant auditer. `Metadata` = qui a accédé à quel secret, quand — sans la valeur. Choisir le niveau d'audit, c'est arbitrer visibilité vs surface d'exposition vs volume de logs (coût Loki/S3 en prod).

📚 Ressources :
- https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/ (doc de référence, à connaître par cœur pour l'exam)
- https://kubernetes.io/docs/reference/config-api/apiserver-audit.v1/

</details>
