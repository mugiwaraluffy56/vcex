# Diagnostics

## Server

- Confirm the process is running.
- Confirm port matches the browser URL.
- Check `/health`.
- Check firewall rules.

## WebSocket

- Confirm `/ws` upgrades.
- Confirm both peers are in the same room.
- Check browser console for close codes.

## WebRTC

- Confirm camera permission.
- Confirm ICE candidates are exchanged.
- Check whether network isolation blocks peer media.
- Try local TURN relay if ICE fails.

## Desktop

- Run `npm run desktop:info`.
- Check Tauri logs.
- Confirm browser fallback still works.

