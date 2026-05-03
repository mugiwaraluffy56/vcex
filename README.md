# LAN Call

Offline LAN video call prototype in Elixir. Elixir serves page and WebSocket signaling. Browser handles camera, mic, video codec, jitter, and WebRTC peer connection.

## Run

```bash
mix run --no-halt
```

Open:

```text
http://localhost:4000
```

## SSH Access

From second machine:

```bash
ssh -L 4000:localhost:4000 user@host-lan-ip
```

Then open `http://localhost:4000`.

## LAN Rules

Both peers must share LAN. No public internet STUN/TURN used. If network has client isolation, signaling may work but media can fail.

## Scripts

- `elixir dev_server.exs`: start local server.
- `elixir call_host.exs 4000`: start server on chosen port.
- `elixir ssh_tunnel.exs`: print SSH tunnel command.
- `elixir call_probe.exs 127.0.0.1`: test TCP reachability.
- `elixir smoke_test.exs`: quick HTTP health test.

See `USING.md` for full local, LAN, SSH, and troubleshooting steps.
