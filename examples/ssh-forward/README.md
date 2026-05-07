# SSH Forward Example

On the client machine:

```bash
ssh -L 4000:localhost:4000 user@host-lan-ip
```

Then open:

```text
http://localhost:4000
```

This keeps browser access local while the server runs on the remote host.

