# Support

vcex is an early prototype. The fastest support path is a reproducible local report.

## Before Opening an Issue

Run:

```bash
mix test
elixir smoke_test.exs
elixir call_probe.exs 127.0.0.1
```

If the problem involves another machine, also note:

- Host operating system.
- Client operating system.
- Browser or desktop app version.
- Whether both machines are on the same LAN.
- Whether the network blocks peer-to-peer traffic.

## Troubleshooting Docs

- `docs/network.md`
- `docs/ssh.md`
- `docs/turn.md`
- `docs/desktop.md`

