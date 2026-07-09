## Step 2 – Allow specific traffic

**Allow frontend→api on port 8080 (AND logic — 1 dash):**
```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-api
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: frontend
      podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 8080
EOF
```

> **⚠ Critical trap — AND vs OR:**
> - **1 dash** under `from:` = AND (same list item = both conditions required)
> - **2 dashes** under `from:` = OR (separate items = either condition)

**Allow DNS egress (ALWAYS needed after deny-all egress):**
```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns-egress
  namespace: backend
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - ports:
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 53
EOF
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Le piège AND/OR — pourquoi c'est du YAML, pas du réseau :**
Un item de liste YAML (`-`) = un bloc de conditions. Dans un même item, `namespaceSelector` + `podSelector` sont un AND (le pod doit matcher les deux). Deux items séparés = OR. Un seul tiret mal placé transforme "frontend du namespace frontend" en "n'importe quel pod du namespace frontend OU n'importe quel pod nommé frontend de n'importe quel namespace" — une faille de sécurité silencieuse qui passe `kubectl apply` sans erreur. Même famille de piège que tes clés YAML dupliquées dans les values Helm.

**Pourquoi DNS egress est-il TOUJOURS oublié ?**
Après un deny-all egress, les pods ne peuvent plus résoudre `kubernetes.default` ni aucun service. Symptôme trompeur : "connection timeout" alors que la cause est la résolution DNS. Port 53 **UDP ET TCP** (TCP pour les réponses > 512 bytes et les retries). Tu as vécu un cousin de ce problème avec ta boucle DNS Tailscale/CoreDNS.

📚 Ressources :
- https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors (section officielle sur AND vs OR)
- https://docs.cilium.io/en/stable/security/policy/ (comment Cilium étend le modèle)

</details>
