## Step 2 – Apply all fixes

**Fix 1 – Remove develop from docker group:**
```bash
gpasswd -d develop docker
grep docker /etc/group
```

**Fix 2 – Fix socket ownership:**
```bash
chown root:root /var/run/docker.sock
ls -la /var/run/docker.sock
```

**Fix 3 – Switch TCP → Unix socket:**
```bash
vim /lib/systemd/system/docker.service
```
Find the `ExecStart` line and change:
`-H tcp://0.0.0.0:2375` → `-H unix:///var/run/docker.sock`

Then reload and restart:
```bash
systemctl daemon-reload
systemctl restart docker
systemctl status docker
```

> **⚠ Critical:** `daemon-reload` MUST run before `restart`, otherwise systemd uses the old config.

Exit node01 when done:
```bash
exit
```

Click **Check** to validate.