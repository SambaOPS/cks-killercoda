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