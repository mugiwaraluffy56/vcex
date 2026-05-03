# TURN Relay

vcex can force WebRTC media through a local TURN relay when direct LAN peer-to-peer UDP fails.

## Install coturn

```bash
brew install coturn
```

## Start TURN

Terminal 1:

```bash
elixir start_turn.exs
```

This starts TURN on:

```text
HOST_LAN_IP:3478
```

Default credentials:

```text
username: vcex
password: vcex-local-turn
```

## Start vcex

Terminal 2:

```bash
mix run --no-halt
```

The browser receives TURN config from:

```text
http://localhost:4000/config.json
```

## Firewall

Allow inbound UDP/TCP `3478` and UDP relay ports `49160-49200` on the host.

## Notes

TURN relays media through the host, so it is more reliable than direct peer-to-peer on isolated LANs. It uses more host CPU/network than direct WebRTC but should work for one-to-one LAN calls.
