# HTTP Reference

## Routes

| Route | Purpose |
| --- | --- |
| `/` | Browser client |
| `/health` | Health check |
| `/ws` | WebSocket upgrade |
| static files | Assets from `public/` |

## Notes

The server intentionally keeps request handling small. Add tests when changing parsing, headers, or content length behavior.

