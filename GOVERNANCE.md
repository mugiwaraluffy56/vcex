# Governance

vcex is maintainer-led.

## Decision Principles

1. Offline and LAN functionality comes first.
2. Small explicit protocol code is preferred over hidden framework behavior.
3. Security tradeoffs must be documented before widening access.
4. Features should be testable without paid services.
5. Desktop and browser experiences should share the same signaling contract.

## Project Areas

- Core server: HTTP, WebSocket, room relay, configuration.
- Browser client: static call UI and WebRTC flow.
- Desktop shell: Tauri wrapper and native app packaging.
- Operations: SSH, local TURN, diagnostics, Docker.
- Documentation: setup, troubleshooting, security, release notes.

