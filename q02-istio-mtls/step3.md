## Step 3 – Restart to inject the sidecar

```bash
kubectl rollout restart deployment web-app -n secured-app
kubectl rollout status deployment web-app -n secured-app
```

Verify the sidecar is injected (pod should show **2/2**):

```bash
kubectl get pods -n secured-app
# NAME          READY   STATUS
# web-app-xxx   2/2     Running   ← 2/2 = app + istio-proxy
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi `rollout restart` et pas `delete pod` ?**
Les deux forcent la recréation (donc l'injection), mais `rollout restart` respecte la `RollingUpdate` strategy et les PDB → zéro downtime, et c'est un état observable/déclaratif. `delete pod` sur un Deployment mono-replica = coupure de service. Réflexe prod : on ne tue jamais des pods à la main quand un mécanisme contrôlé existe.

**Le `2/2` comme signal** : READY compte les containers. 1/1 = pas de sidecar = trafic hors mesh = trou dans le mTLS STRICT (le pod sera rejeté par les autres). Vérifier le READY count est le smoke test le plus rapide du mesh.

📚 Ressources :
- https://istio.io/latest/docs/ops/common-problems/injection/

</details>
