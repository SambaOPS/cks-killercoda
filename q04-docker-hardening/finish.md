## Lab Complete! 🎉

### Why these settings matter
| Risk | Impact | Fix |
|------|--------|-----|
| User in docker group | Equivalent to root via `docker run -v /:/host` | `gpasswd -d` |
| TCP socket 2375 | API Docker exposed without auth on network | Unix socket only |
| Socket wrong owner | Unauthorized access | `chown root:root` |

### Key tips for the exam
- `daemon-reload` is **mandatory** before restart
- Verify with `ss -tlnp | grep 2375` — should return nothing
- `deluser develop docker` also works on Debian/Ubuntu

### Next lab
Try **Q13 – AppArmor** for more system hardening practice.