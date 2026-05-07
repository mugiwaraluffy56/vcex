# ADR 0001: Offline-First LAN Operation

## Status

Accepted.

## Context

vcex is meant to work when public internet services are unavailable or undesirable.

## Decision

The default runtime must avoid public signaling, STUN, TURN, account, analytics, and telemetry services.

## Consequences

- The app is easier to trust on private networks.
- NAT traversal is less powerful by default.
- Local TURN is documented as an explicit fallback.

