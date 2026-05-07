# API

vcex has a small HTTP and WebSocket surface.

## HTTP

### `GET /`

Serves the browser client.

### `GET /health`

Returns a plain health response.

### Static Assets

Files under `public/` are served directly.

## WebSocket

### `GET /ws`

Upgrades to a WebSocket used for signaling messages.

Expected payloads are browser-generated WebRTC signaling messages such as:

- `offer`
- `answer`
- `candidate`
- room or peer metadata

The server relays messages to other peers in the same room. It does not inspect media.

