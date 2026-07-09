## Step 1 – Default deny all

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: backend
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF
```

Verify:
```bash
kubectl get networkpolicy -n backend
```

> After this, **ALL** traffic in/out of backend pods is blocked — including DNS!

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi commencer par default-deny ?**
Sans NetworkPolicy, K8s est **allow-all par défaut** — n'importe quel pod compromis peut scanner tout le cluster (lateral movement). Le default-deny inverse le modèle : on passe d'une blocklist impossible à maintenir à une allowlist explicite. C'est le principe **zero-trust / least privilege appliqué au réseau**.

**Pourquoi `podSelector: {}` ?**
Le sélecteur vide matche TOUS les pods du namespace. Piège inverse : omettre `policyTypes: [Egress]` = l'egress reste ouvert (une policy ne restreint que les types déclarés).

**Point sémantique crucial** : les NetworkPolicies sont **additives** (OR entre policies). Il n'existe pas de policy "deny X" — on ne peut que réduire ce qui est autorisé. Ton Cilium sur le homelab implémente ça via eBPF, pas iptables.

📚 Ressources :
- https://kubernetes.io/docs/concepts/services-networking/network-policies/
- https://networkpolicy.io/ (éditeur visuel — excellent pour vérifier AND/OR)

</details>
