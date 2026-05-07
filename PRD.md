# Product Requirements

## Problem

Small trusted teams sometimes need a video call that works on a local network or through SSH forwarding without depending on public cloud conferencing infrastructure.

## Goal

Build a reliable offline-first LAN call tool with a browser fallback and desktop shell.

## Non-Goals

- Public meeting platform.
- Cloud account system.
- Paid relay service.
- Large media server.

## Users

- Developers pairing on a LAN.
- Home lab users.
- Field teams with limited internet.
- Operators using SSH access to a private machine.

## v0.1 Requirements

- Start local server with one command.
- Serve static browser client.
- Upgrade WebSocket connections.
- Relay WebRTC signaling between peers.
- Provide health check.
- Document SSH and TURN fallback paths.

## v0.2 Requirements

- Room names in URL.
- Copy invite link.
- Mute camera and microphone.
- Device selection.
- Connection diagnostics.

