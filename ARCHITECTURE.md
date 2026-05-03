# Architecture

`LanCall.Server` accepts TCP HTTP requests. Static files come from `public/`. Requests to `/ws` upgrade to WebSocket and join `LanCall.Room`.

Room process stores connected callers. Any signaling message from one browser is broadcast to other peers in same room. Browser JavaScript creates WebRTC offer/answer and exchanges ICE candidates through WebSocket.

Media does not pass through Elixir. Browser-to-browser LAN path gives best latency and avoids server CPU bottleneck.
