# Verification

Use this checklist before merging meaningful changes.

## Required

```bash
mix format --check-formatted
mix test
elixir smoke_test.exs
```

## Browser

1. Start `mix run --no-halt`.
2. Open `http://localhost:4000`.
3. Confirm `/health` returns `ok`.
4. Open two browser tabs in the same room.
5. Confirm signaling reaches both tabs.

## LAN

1. Start the server on the host.
2. Find host LAN IP.
3. Open `http://host-lan-ip:4000` from a second device.
4. Confirm camera permission prompt appears.
5. Confirm ICE reaches connected or documented failure state.

## SSH

1. Run `elixir ssh_tunnel.exs`.
2. Start the printed SSH tunnel.
3. Open `http://localhost:4000` on the client machine.

## Desktop

```bash
npm run desktop:info
npm run desktop:dev
```

