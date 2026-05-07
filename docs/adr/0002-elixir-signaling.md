# ADR 0002: Elixir Signaling Server

## Status

Accepted.

## Context

The project needs a small server for static files, WebSocket upgrades, and room relay.

## Decision

Use Elixir processes for the signaling path and keep media outside the server.

## Consequences

- The signaling server stays small.
- WebRTC media avoids server CPU load.
- Room state can be modeled with lightweight processes.

