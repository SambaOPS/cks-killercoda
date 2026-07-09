## Step 2 – Apply all three fixes

**Fix 1 – Remove develop from docker group:**
```bash
gpasswd -d develop docker
grep docker /etc/group
# 'develop' must not appear anymore
```

**Fix 2 – Fix Docker socket ownership:**
```bash
chown root:root /var/run/docker.sock
ls -la /var/run/docker.sock
# srw-rw---- 1 root root ...
```

**Fix 3 – Switch from TCP to Unix socket:**
```bash
vim /lib/systemd/system/docker.service
```

Find the `ExecStart` line. In a real system it looks like:
```
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H fd:// --containerd=/run/containerd/containerd.sock
```

Remove only the `-H tcp://0.0.0.0:2375` part, keep the rest:
```
ExecStart=/usr/bin/dockerd -H unix:///var/run/docker.sock -H fd:// --containerd=/run/containerd/containerd.sock
```

> **⚠ Important:** Keep `-H fd://` and `--containerd=` — only remove the TCP socket part.

Then reload and restart:
```bash
systemctl daemon-reload
systemctl restart docker
systemctl status docker
```

Verify TCP port is closed:
```bash
ss -tlnp | grep 2375
# Must return empty — nothing listening on 2375
```

Exit node01:
```bash
exit
```

Click **Check** to validate.


---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi retirer seulement `-H tcp://` et garder `fd://` ?**
`fd://` = socket activation systemd (le socket Unix local, légitime) ; `--containerd` = lien vers le runtime. Supprimer toute la ligne ExecStart ou ces flags = daemon qui ne démarre plus. Le principe : **chirurgie minimale** — on retire la surface d'exposition, pas la fonctionnalité. Même discipline que le trap kube-bench "change le flag, n'en ajoute pas un deuxième".

**Pourquoi `daemon-reload` obligatoire ?** systemd cache les unit files en mémoire ; sans reload, `restart` relance l'ancienne config — le "fix" ne s'applique jamais et le check échoue. Failure mode silencieux classique.

**Si TCP est vraiment nécessaire en prod** (CI distante) : mTLS obligatoire (`--tlsverify`) sur le port 2376 — jamais 2375 nu.

📚 Ressources :
- https://docs.docker.com/engine/security/protect-access/#use-tls-https-to-protect-the-docker-daemon-socket

</details>
