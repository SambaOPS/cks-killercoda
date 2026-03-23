## Lab Complete! 🎉

### What you practiced
- Writing a custom Falco rule in `falco_rules.local.yaml`
- Using `evt.type`, `fd.name`, `container.id` condition fields
- Controlling output format with Falco macros
- Scaling Deployments to 0 as a remediation action

### Key tips for the exam
- **Never** edit `falco_rules.yaml` — always use `falco_rules.local.yaml`
- The output format is **exactly** checked — copy it from the question
- `fd.name = /dev/mem` uses `=` for exact match, not `contains`
- After `systemctl restart falco`, wait 5s before testing

### Next lab
Try **Q11 – Audit Logging** (also in the Monitoring domain, 20% weight)