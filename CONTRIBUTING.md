# Contributing

vcex is an offline-first LAN video-call prototype. Contributions should preserve the main constraint: the app must remain useful without public internet services.

## Development Setup

Install Elixir, Erlang/OTP, Node.js, and Rust if you plan to run the Tauri desktop shell.

```bash
mix test
mix format --check-formatted
elixir smoke_test.exs
npm run desktop:info
```

For browser-only work, run:

```bash
mix run --no-halt
```

Then open `http://localhost:4000`.

## Code Style

- Format Elixir with `mix format`.
- Keep protocol handling explicit and small.
- Prefer standard library modules over dependencies.
- Keep offline behavior working by default.
- Document new scripts in `README.md` or `docs/`.

## Pull Request Checklist

- Summary of behavior changed.
- Test commands and results.
- LAN notes if networking changed.
- Browser or desktop screenshot for UI changes.
- Security notes if authentication, tunneling, or TURN changed.

