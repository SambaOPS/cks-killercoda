## Lab Complete! 🎉

### Key tips for the exam
- **Change** existing flags — never add a second one with the same name
- Verify with: `ps -ef | grep kube-apiserver | tr ' ' '\n' | grep <flag>`
- etcd fixes are filesystem, not API server manifest changes
- Use `kube-bench run --check=<id>` to verify specific fixes