## Step 1 – Fix the Dockerfile (1 line)

```bash
cat /opt/course/q06/Dockerfile
# Find: USER root
```

Change **only** that line:
```bash
sed -i 's/^USER root/USER nobody/' /opt/course/q06/Dockerfile
grep '^USER' /opt/course/q06/Dockerfile
# → USER nobody ✅
```

> **⚠ Constraint:** Do NOT add extra lines or blocks — change the existing `USER` line only.


---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi `USER root` est-il LE finding n°1 des analyses statiques ?**
Sans directive USER, ou avec USER root, le process tourne en uid 0 **dans** le container : toute RCE donne immédiatement root du namespace, et chaque faille de runtime/kernel devient un container escape potentiel. `USER nobody` (uid 65534) réduit le blast radius à un compte sans droits ni home.

**Pourquoi la contrainte "1 ligne seulement" ?**
Elle simule les graders automatiques ET la discipline de MR : un diff minimal est reviewable et sans effet de bord. Hansel/Checkov/hadolint flaggent exactement cette règle (hadolint DL3002) — c'est le même type de gate que ton Checkov dans le pipeline Terraform BNP.

📚 Ressources :
- https://github.com/hadolint/hadolint/wiki/DL3002
- https://docs.docker.com/develop/develop-images/instructions/#user

</details>
