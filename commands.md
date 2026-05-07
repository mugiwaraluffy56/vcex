# Commands

## Server

```bash
mix run --no-halt
PORT=4050 mix run --no-halt
elixir dev_server.exs
elixir call_host.exs 4000
```

## Checks

```bash
mix test
mix format --check-formatted
elixir smoke_test.exs
elixir call_probe.exs 127.0.0.1
```

## Desktop

```bash
npm run desktop:info
npm run desktop:dev
npm run desktop:build
```

## SSH

```bash
elixir ssh_tunnel.exs
ssh -L 4000:localhost:4000 user@host-lan-ip
```

## TURN

```bash
elixir start_turn.exs
```

