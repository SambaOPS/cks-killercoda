## Step 1 – Inspect the misconfigurations

SSH to the worker node:

```bash
ssh node01
```

Check the three issues:

```bash
# Issue 1: develop in docker group
grep docker /etc/group

# Issue 2: socket ownership
ls -la /var/run/docker.sock

# Issue 3: TCP socket in service file
grep ExecStart /lib/systemd/system/docker.service
```

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi ces trois points précis ?**
Ils partagent la même racine : **l'accès au daemon Docker = root sur l'hôte**. Qui parle au socket peut lancer `docker run --privileged -v /:/host` et posséder la machine. Donc :
1. Membre du groupe `docker` = root sans sudo ni audit trail.
2. Socket ownership laxiste = même chose pour d'autres users.
3. Socket TCP `0.0.0.0:2375` = root **à distance, sans authentification ni TLS** — c'est le vecteur d'attaque des botnets de cryptomining (scans permanents du port 2375 sur Internet).

**Méthode** : toujours inventorier les trois surfaces (group membership, permissions fichier, exposition réseau) avant de toucher — un fix isolé laisse les deux autres portes ouvertes.

📚 Ressources :
- https://docs.docker.com/engine/security/#docker-daemon-attack-surface
- https://docs.docker.com/engine/security/protect-access/

</details>
