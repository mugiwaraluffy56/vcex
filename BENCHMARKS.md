# Benchmarks

This project currently tracks simple operational benchmarks.

## Targets

| Check | Target |
| --- | --- |
| `/health` response | Under 100 ms locally |
| Static asset response | Under 200 ms locally |
| WebSocket frame encode/decode tests | Under 1 second in suite |
| Smoke test | Under 5 seconds |

## Commands

```bash
time elixir smoke_test.exs
time mix test
```

Future diagnostics should include call setup time, ICE connection time, bitrate, RTT, packet loss, and frame drops.

