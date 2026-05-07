# Compatibility

## Runtime

- Elixir `~> 1.19`
- Erlang/OTP compatible with the selected Elixir version
- Node.js for Tauri CLI tasks
- Rust toolchain for Tauri builds

## Browsers

Target modern Chromium, Firefox, and Safari versions with WebRTC support.

Camera access is easiest on `localhost`. Remote HTTP origins may require HTTPS depending on browser policy.

## Networks

Supported:

- Same-machine local testing.
- Same-LAN peer calls.
- SSH-forwarded browser access.
- Local TURN relay for isolated networks.

Not currently supported:

- Untrusted public internet exposure.
- Multi-party SFU calls.
- NAT traversal through public relay infrastructure by default.

