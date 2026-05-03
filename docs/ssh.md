# SSH Notes

Host machine runs `mix run --no-halt`.

Guest machine connects:

```bash
ssh -L 4000:localhost:4000 user@host-lan-ip
```

Guest opens:

```text
http://localhost:4000
```

SSH protects server access. WebRTC media still tries direct LAN path for speed.
