## Step 3 – Scale down the offending Deployments

```bash
kubectl scale deploy nvidia -n production --replicas=0
kubectl scale deploy cpu    -n production --replicas=0
kubectl scale deploy ollama -n production --replicas=0
```

Verify:

```bash
kubectl get deploy -n production
kubectl get pods -n production
# Should show no running pods
```

Click **Check** to validate your solution.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi `scale --replicas=0` et pas `kubectl delete` ?**
Trois raisons d'ingénieur :
1. **Préservation forensique** : le Deployment (spec, image digest, labels) reste dans etcd — indispensable pour l'investigation post-incident.
2. **Réversibilité** : `scale --replicas=1` restaure le service en une commande une fois l'incident clos.
3. **GitOps-compat** : delete + recréation par ArgoCD = boucle. Scale à 0 est un état déclaratif observable. (Tu as fait exactement ça avec le load generator d'Online Boutique.)

C'est le pattern **containment** de la réponse à incident : isoler sans détruire les preuves.

📚 Ressources :
- https://kubernetes.io/docs/concepts/security/ (K8s security concepts)
- https://www.cisa.gov/sites/default/files/publications/Federal_Government_Cybersecurity_Incident_and_Vulnerability_Response_Playbooks_508C.pdf (containment vs eradication)

</details>
