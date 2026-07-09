## Step 2 – Fix the Deployment (1 line) and apply

```bash
cat /opt/course/q06/deploy.yaml | grep readOnly
# → readOnlyRootFilesystem: false
```

Change **only** that line:
```bash
sed -i 's/readOnlyRootFilesystem: false/readOnlyRootFilesystem: true/' \
  /opt/course/q06/deploy.yaml
```

Apply:
```bash
kubectl apply -f /opt/course/q06/deploy.yaml
kubectl rollout status deploy static-app -n static-analysis
```

Click **Check** to validate.


---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi `readOnlyRootFilesystem: true` ?**
Un attaquant qui obtient une exécution dans le container ne peut plus : écrire un binaire, modifier les libs, dropper un webshell, altérer la config. L'immutabilité transforme une compromission persistante en compromission volatile (morte au restart). Si l'app a besoin d'écrire → `emptyDir` monté sur le chemin précis (/tmp, /var/cache) : on autorise l'écriture *ciblée*, pas générale.

**Static analysis = shift-left** : ces deux fixes (Dockerfile + manifest) sont attrapables en CI avant tout déploiement — c'est exactement là que tes gates Trivy/Checkov apportent leur valeur : le coût d'un fix en MR est 100× inférieur au même fix en incident.

📚 Ressources :
- https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

</details>
