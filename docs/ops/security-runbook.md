# Security Runbook

## Safe Defaults

- Bind locally or to trusted LANs only.
- Use SSH forwarding for remote access.
- Do not expose `4000` publicly without adding authentication.
- Keep TURN credentials local.

## Incident Checklist

1. Stop exposed server.
2. Rotate any local TURN credentials.
3. Review shell history for leaked commands.
4. Check changed config files.
5. Document the network path that was exposed.

