# Benchmarks

Benchmark work lives here. Keep scripts local-first and runnable without external services.

## Planned Suites

- HTTP health latency.
- Static asset serving latency.
- WebSocket frame throughput.
- Two-peer signaling setup time.
- Browser call setup timing.

## Baseline Command

```bash
time elixir smoke_test.exs
time mix test
```

