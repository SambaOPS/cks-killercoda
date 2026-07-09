## Step 1 – Enable sidecar injection

Label the namespace:

```bash
kubectl label namespace secured-app istio-injection=enabled

# Verify the label
kubectl get namespace secured-app --show-labels
```

> **⚠ Trap:** Labeling the namespace does NOT retroactively inject sidecars into existing pods. You must restart them.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi l'injection passe par un label de namespace ?**
L'injection de sidecar est faite par un **mutating admission webhook** : à la création du pod, Istio réécrit le spec pour y ajouter `istio-proxy` et l'init container iptables. Un webhook n'agit qu'à l'admission — d'où le piège : les pods déjà en vie ne sont jamais réécrits. Même mécanique que tes mutate policies Kyverno : elles ne touchent que les objets qui passent par l'API après leur activation.

**Parallèle homelab** : ton Cilium offre le mTLS sans sidecar (WireGuard/SPIFFE au niveau eBPF) — connaître les deux approches (sidecar vs sidecar-less) est une vraie question d'entretien plateforme.

📚 Ressources :
- https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/
- https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/

</details>
