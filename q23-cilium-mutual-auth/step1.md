## Step 1 – Key Cilium syntax vs standard NetworkPolicy

| Standard NetworkPolicy | CiliumNetworkPolicy |
|------------------------|---------------------|
| `podSelector` | `endpointSelector` |
| `from.podSelector` | `fromEndpoints[].matchLabels` |
| `namespaceSelector` | `k8s:io.kubernetes.pod.namespace` label |
| N/A | `authentication.mode: required` |
| N/A | `fromEntities: [host]` |

```bash
kubectl get pods -n kube-system | grep cilium
kubectl get crd | grep cilium
```

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi Cilium a-t-il sa propre CRD au lieu d'étendre NetworkPolicy ?**
La NetworkPolicy standard est un plus petit dénominateur commun (L3/L4, pod/namespace selectors). Cilium exploite eBPF pour aller au-delà : identités (`fromEntities: host/world/cluster`), L7 (filtrage HTTP par méthode/path), FQDN egress, et **mutual auth SPIFFE sans sidecar**. La table de correspondance de ce step est à mémoriser — l'exam teste précisément la traduction entre les deux dialectes.

**`endpointSelector` vs `podSelector`** : Cilium raisonne en *endpoints* à identités labellisées, pas en pods — d'où la référence au namespace via le label spécial `k8s:io.kubernetes.pod.namespace` plutôt qu'un namespaceSelector.

📚 Ressources :
- https://docs.cilium.io/en/stable/security/policy/
- https://docs.cilium.io/en/stable/network/servicemesh/mutual-authentication/mutual-authentication/

</details>
