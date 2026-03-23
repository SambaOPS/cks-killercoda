# CKS Killercoda Labs

23 interactive labs based on real CKS exam reports from 2024-2025.
Each lab deploys the exact scenario described by candidates, with automated verification.

## How to use
1. Import this repo into your Killercoda creator account
2. Each scenario deploys a live 2-node Kubernetes cluster
3. `background.sh` sets up the pre-state automatically
4. Click **Check** on the last step to verify your solution

## Labs

| Lab | Topic | Domain | Difficulty |
|-----|-------|--------|-----------|
| [q01-falco-devmem](q01-falco-devmem/) | Falco: Detect /dev/mem Access | Monitoring, Logging & Runtime Security (20%) | intermediate |
| [q02-istio-mtls](q02-istio-mtls/) | Istio: mTLS PeerAuthentication | Minimize Microservice Vulnerabilities (20%) | beginner |
| [q03-ingress-tls](q03-ingress-tls/) | Ingress TLS + HTTP→HTTPS Redirect | Cluster Setup (15%) | beginner |
| [q04-docker-hardening](q04-docker-hardening/) | Docker Daemon Hardening | System Hardening (10%) | intermediate |
| [q07-tls-secret](q07-tls-secret/) | TLS Secret: Create and Mount in Deployment | Minimize Microservice Vulnerabilities (20%) | beginner |
| [q08-networkpolicy](q08-networkpolicy/) | NetworkPolicy: Default-Deny + Selective Allow | Cluster Setup (15%) | advanced |
| [q09-rbac](q09-rbac/) | RBAC: Least-Privilege ServiceAccount | Cluster Hardening (15%) | intermediate |
| [q11-audit-logging](q11-audit-logging/) | Audit Logging: Policy + API Server Config | Monitoring, Logging & Runtime Security (20%) | advanced |
| [q12-kube-bench](q12-kube-bench/) | kube-bench: CIS Benchmark Remediation | Cluster Setup + Cluster Hardening (30%) | intermediate |
| [q17-kubelet-hardening](q17-kubelet-hardening/) | Kubelet Hardening: Disable Anonymous Auth | Cluster Hardening (15%) | intermediate |
| [q18-container-immutability](q18-container-immutability/) | Container Immutability: SecurityContext Hardening | Minimize Microservice Vulnerabilities (20%) | beginner |
| [q19-sa-projected-volume](q19-sa-projected-volume/) | ServiceAccount: Disable Automount + Projected Token | Cluster Hardening (15%) | intermediate |
| [q20-cluster-upgrade](q20-cluster-upgrade/) | Cluster Node Upgrade (kubeadm) | Cluster Setup (15%) | intermediate |
| [q21-pss-fix-deployment](q21-pss-fix-deployment/) | PSS: Fix Deployment for Restricted Standard | Minimize Microservice Vulnerabilities (20%) | intermediate |
| [q22-imagepolicywebhook](q22-imagepolicywebhook/) | ImagePolicyWebhook: Deny Images When Unavailable | Supply Chain Security (20%) | advanced |
| [q15-encryption-at-rest](q15-encryption-at-rest/) | Secrets Encryption at Rest (aescbc) | Minimize Microservice Vulnerabilities (20%) | advanced |
| [q16-runtimeclass](q16-runtimeclass/) | RuntimeClass: gVisor Sandboxed Container | Minimize Microservice Vulnerabilities (20%) | beginner |
| [q13-apparmor](q13-apparmor/) | AppArmor: Load Profile + Enforce on Pod | System Hardening (10%) | intermediate |
| [q14-psa](q14-psa/) | Pod Security Admission: Enforce Standards | Minimize Microservice Vulnerabilities (20%) | intermediate |
| [q10-trivy](q10-trivy/) | Trivy: Scan Images for Critical CVEs | Supply Chain Security (20%) | intermediate |
| [q23-cilium-mutual-auth](q23-cilium-mutual-auth/) | CiliumNetworkPolicy: Allow + Mutual Authentication | Cluster Setup (15%) | advanced |
| [q05-sbom-bom](q05-sbom-bom/) | SBOM: Find Vulnerable Image + Generate SPDX Report | Supply Chain Security (20%) | advanced |

## Sources
Real exam reports from Reddit (r/devops, r/KubernetesCerts) and Medium, 2024-2025.
Candidates scored 77–90%.
