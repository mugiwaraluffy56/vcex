# Protocol Reference

vcex uses HTTP for static files and WebSocket for signaling.

The server does not terminate or inspect WebRTC media. It relays signaling messages so browsers can negotiate a peer-to-peer path.

## Flow

1. Client loads static assets.
2. Client opens WebSocket.
3. Client joins a room.
4. One peer sends an offer.
5. Other peer sends an answer.
6. Peers exchange ICE candidates.
7. Media flows directly between peers or through configured local TURN.

