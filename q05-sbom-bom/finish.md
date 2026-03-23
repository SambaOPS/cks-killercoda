## Lab Complete! 🎉

### SBOM tools comparison
| Tool | SPDX command | Reliability |
|------|-------------|-------------|
| trivy | `trivy image --format spdx <img>` | Always available |
| bom | `bom generate --image <img> --format spdx` | Check with `which bom` |

### Key tips for the exam
- Verify `which bom` before using it — may not be installed
- SPDX output starts with `SPDXVersion:` — verify the file
- `mkdir -p` before redirecting output