## Step 2 – Apply strict mTLS

Create the PeerAuthentication resource:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: secured-app
spec:
  mtls:
    mode: STRICT
EOF
```

Verify:
```bash
kubectl get peerauthentication -n secured-app
```

> **⚠ Trap:** `kind: PeerAuthentication` — not `NetworkPolicy`.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi `PeerAuthentication` et pas une NetworkPolicy ?**
Deux couches différentes : NetworkPolicy = L3/L4 (qui peut parler à qui). PeerAuthentication = **identité cryptographique** (comment on prouve qui on est, via certificats SPIFFE émis par istiod). `STRICT` refuse tout trafic non-mTLS ; `PERMISSIVE` (défaut) accepte les deux — utile en migration, dangereux en cible finale car un client non-meshé passe en clair sans erreur.

**Pourquoi `name: default` dans le namespace ?** Convention Istio : la PeerAuthentication de portée namespace s'applique à tous les workloads sans selector. Une policy mesh-wide vivrait dans `istio-system`.

📚 Ressources :
- https://istio.io/latest/docs/reference/config/security/peer_authentication/
- https://istio.io/latest/docs/concepts/security/#mutual-tls-authentication

</details>
