## Step 1 – Drain node01

```bash
kubectl get nodes
# Note the control plane version — that is the target

kubectl drain node01 \
  --ignore-daemonsets \
  --delete-emptydir-data \
  --force

kubectl get nodes
# node01 should show SchedulingDisabled
```

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi drain AVANT toute opération ?**
Le drain fait deux choses : cordon (plus de nouveau scheduling) + éviction gracieuse (respect des PDB et des terminationGracePeriod). Upgrader un kubelet avec des workloads dessus = restarts non maîtrisés en plein milieu. `--ignore-daemonsets` est obligatoire car les DaemonSets (Cilium, Falco, node-agent Velero chez toi) sont re-schedulés instantanément sur le même node — les évincer n'a pas de sens.

**`--delete-emptydir-data`** : rappel que les emptyDir meurent avec l'éviction — si une donnée y est précieuse, le problème est architectural (elle devrait être dans un PV), pas opérationnel.

📚 Ressources :
- https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/
- https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/

</details>
