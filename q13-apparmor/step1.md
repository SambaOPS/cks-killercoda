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