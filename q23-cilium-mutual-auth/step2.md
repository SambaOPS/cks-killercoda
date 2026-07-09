## Step 2 – Apply the policy

```bash
kubectl apply -f - <<'YAML'
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: backend-ingress
  namespace: mutual-auth
spec:
  endpointSelector:
    matchLabels:
      app: backend
  ingress:
  # Rule 1: frontend pods with mutual TLS
  - fromEndpoints:
    - matchLabels:
        app: frontend
        k8s:io.kubernetes.pod.namespace: frontend-ns
    authentication:
      mode: required
  # Rule 2: host (node) without mutual auth
  - fromEntities:
    - host
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
    authentication:
      mode: disabled
YAML
```

> **⚠ `authentication` is a SIBLING of `fromEndpoints`** — not nested inside it.

```bash
kubectl get ciliumnetworkpolicy -n mutual-auth
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi `authentication` est sibling de `fromEndpoints` ?**
Chaque item de la liste `ingress` est une **règle complète** : source (`fromEndpoints`/`fromEntities`) + conditions (`toPorts`) + exigences (`authentication`). L'authentification qualifie la règle entière, pas la source. L'indenter sous `fromEndpoints` produit un YAML valide... qui ignore silencieusement le champ (CRD avec champs inconnus tolérés selon la validation). Cousin direct du piège AND/OR de q08 : en YAML, l'indentation EST la sémantique.

**Pourquoi la règle host sans mutual auth ?**
Les health checks kubelet viennent du node (entity `host`), qui n'a pas d'identité SPIFFE de workload — exiger le mTLS le bloquerait et les probes tueraient les pods. Pattern récurrent : toute policy stricte a besoin de ses exceptions d'infrastructure explicites (même logique que ton allow-DNS après deny-all, ou tes PolicyExceptions Kyverno pour les namespaces plateforme).

**Sur ton homelab** : ton Cilium supporte ça nativement — activer la mutual auth sur Online Boutique serait une démo d'entretien très différenciante.

📚 Ressources :
- https://docs.cilium.io/en/stable/network/servicemesh/mutual-authentication/mutual-authentication-example/

</details>
