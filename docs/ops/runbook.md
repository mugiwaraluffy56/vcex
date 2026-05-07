# Runbook

## Start Server

```bash
mix run --no-halt
```

## Check Health

```bash
curl http://localhost:4000/health
```

## Change Port

```bash
PORT=4050 mix run --no-halt
```

## Verify LAN Reachability

```bash
elixir call_probe.exs host-lan-ip
```

## Stop Server

Use `Ctrl-C` twice in the terminal running the server.

