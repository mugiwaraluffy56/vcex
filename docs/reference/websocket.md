# WebSocket Reference

The WebSocket layer handles frame encode/decode and forwards signaling payloads to the room relay.

## Message Categories

- Room join metadata.
- WebRTC offer.
- WebRTC answer.
- ICE candidate.
- Peer disconnect.

## Failure Modes

- Bad upgrade headers.
- Unsupported frame type.
- Peer disconnect.
- Room process unavailable.

