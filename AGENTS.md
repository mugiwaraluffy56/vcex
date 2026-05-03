# Repository Guidelines

## Project Structure & Module Organization

This is an offline LAN video-call prototype in Elixir. Core server code lives in `lib/lan_call/`: `server.ex` handles TCP HTTP, `websocket.ex` handles frame encode/decode, and `room.ex` relays WebRTC signaling between peers. Browser client files live in `public/`. Tests live in `test/lan_call/`. Root `.exs` scripts are kept for quick operations: `dev_server.exs`, `call_host.exs`, `call_probe.exs`, `smoke_test.exs`, and `ssh_tunnel.exs`.

## Build, Test, and Development Commands

- `mix run --no-halt`: start LAN Call on `0.0.0.0:4000`.
- `elixir dev_server.exs`: start same server without Mix app boot.
- `elixir call_host.exs 4000`: start server on chosen port.
- `elixir smoke_test.exs`: run quick HTTP `/health` smoke test.
- `mix test`: run ExUnit tests.
- `mix format --check-formatted`: verify Elixir formatting.

Open `http://localhost:4000` on host. Over SSH, forward with `ssh -L 4000:localhost:4000 user@host-lan-ip`.

## Coding Style & Naming Conventions

Use `mix format` for all `.ex` and `.exs` files. Use 2-space indentation. Elixir modules use `LanCall.*`; file names use snake case and mirror module purpose, for example `lib/lan_call/websocket.ex`. Keep server protocol code small and explicit; avoid hidden dependencies because this project must work offline.

## Testing Guidelines

Use ExUnit. Put tests under `test/lan_call/` with `_test.exs` suffix. Cover protocol helpers, request parsing, and network-safe utilities. For live server checks, use `elixir smoke_test.exs` rather than long-running browser tests.

## Commit & Pull Request Guidelines

No commits exist yet, so use concise imperative messages such as `Add WebSocket signaling` or `Fix HTTP content length`. Pull requests should include summary, test results, LAN/browser notes, and screenshots for UI changes.

## Security & Configuration Tips

Do not commit secrets or local `.env` files. Use `.env.example` for safe defaults. SSH forwarding protects access to the local web app, but WebRTC media still travels peer-to-peer on LAN. Do not expose port `4000` on untrusted networks without authentication.
