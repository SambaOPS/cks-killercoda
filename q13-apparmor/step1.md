## Step 1 – Load the AppArmor profile

SSH to node01:
```bash
ssh node01
```

Load the profile:
```bash
sudo apparmor_parser -q /opt/course/q13/profile
```

Find the **exact profile name** (from inside the file, NOT the filename):
```bash
grep "^profile" /opt/course/q13/profile
# → profile cks-nginx-deny-write flags=(attach_disconnected) {
# Name = cks-nginx-deny-write
```

Verify it's loaded:
```bash
sudo aa-status | grep cks-nginx-deny-write
# → cks-nginx-deny-write (enforce)
```

Return to control plane:
```bash
exit
```

> **⚠ Critical trap:** Profile name = the value after `profile` keyword inside the file, NOT the filename.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi le nom du profil ≠ nom du fichier ?**
AppArmor enregistre le profil sous le nom déclaré dans la directive `profile <name>` **à l'intérieur** du fichier. Le kernel ne connaît pas les noms de fichiers. Référencer le nom de fichier dans le pod = erreur `CreateContainerError: profile not found`. Piège n°1 de cette question à l'exam.

**Pourquoi charger sur node01 et pas le master ?**
AppArmor est un LSM (Linux Security Module) **du kernel de chaque node**. Le profil doit être chargé sur le node où le pod s'exécute — d'où le `nodeName: node01` du step 2. En prod, on distribue les profils via DaemonSet ou dans l'image du node (Packer/cloud-init) — jamais à la main.

**AppArmor vs seccomp** : AppArmor contrôle les *ressources* (fichiers, capabilities, réseau) par chemin ; seccomp filtre les *syscalls* par numéro. Complémentaires, pas concurrents.

📚 Ressources :
- https://kubernetes.io/docs/tutorials/security/apparmor/
- https://gitlab.com/apparmor/apparmor/-/wikis/Documentation

</details>
