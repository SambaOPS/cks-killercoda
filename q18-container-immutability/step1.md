## Step 1 – Fix the Dockerfile

```bash
cat /opt/course/q18/Dockerfile
```

Find `USER root` and change it to `USER nobody`:

```bash
sed -i 's/USER root/USER nobody/' /opt/course/q18/Dockerfile
grep "^USER" /opt/course/q18/Dockerfile
# → USER nobody
```

> **Do NOT rebuild the image** unless the question explicitly asks for it.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi corriger le Dockerfile ET le manifest (step 2) ?**
Deux couches de la même défense : le Dockerfile fixe le défaut de l'image (build time), le securityContext l'impose au runtime — et gagne en cas de conflit. Corriger seulement l'image = n'importe quel manifest peut override ; corriger seulement le manifest = l'image reste dangereuse ailleurs. Shift-left + enforcement.

**Pourquoi ne PAS rebuilder ?** Scope de l'énoncé, mais aussi une leçon : à l'exam, chaque action hors périmètre consomme du temps et peut casser l'état attendu par le grader. Faire exactement ce qui est demandé, rien de plus.

📚 Ressources :
- https://docs.docker.com/develop/develop-images/instructions/#user

</details>
