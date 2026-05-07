# Configuration

vcex keeps configuration small and environment-driven.

## Environment

| Variable | Default | Purpose |
| --- | --- | --- |
| `PORT` | `4000` | HTTP and WebSocket server port |
| `HOST` | `0.0.0.0` | Bind address |
| `VCEX_TURN_HOST` | unset | Optional local TURN host |
| `VCEX_TURN_PORT` | unset | Optional local TURN port |
| `VCEX_TURN_USERNAME` | unset | Optional TURN username |
| `VCEX_TURN_PASSWORD` | unset | Optional TURN password |

See `.env.example` for safe local defaults.

## Config Files

- `config/config.exs`: default application config.
- `config/test.exs`: test overrides.
- `turnserver.conf`: local coturn example.

