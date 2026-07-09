## Step 3 – Uncordon and verify

```bash
kubectl uncordon node01
kubectl get nodes
# Both nodes: same version + Ready ✅
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi l'uncordon est-il si souvent oublié ?**
Parce que tout "marche" sans lui : le node est Ready, la version est bonne — mais il ne reçoit plus aucun pod. Sur un cluster à 2 workers, c'est 50% de capacité perdue silencieusement, découverte des jours plus tard quand l'autre node sature. Checklist mentale : drain → upgrade → **uncordon** → verify, comme une transaction qu'on referme.

**Vérif finale** : `kubectl get nodes` doit montrer même version + Ready + SchedulingDisabled disparu. En prod, on ajoute un smoke test workload avant de passer au node suivant.

📚 Ressources :
- https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/#recovering-from-a-failure-state

</details>
