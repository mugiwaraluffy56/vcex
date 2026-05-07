# Security Policy

vcex is intended for trusted LANs and local SSH-forwarded access. It does not currently provide production-grade authentication.

## Supported Versions

| Version | Supported |
| --- | --- |
| 0.1.x | Yes |

## Reporting a Vulnerability

Open a private security advisory or contact the maintainer directly. Include:

- Affected version or commit.
- Reproduction steps.
- Expected impact.
- Suggested mitigation, if known.

## Security Boundaries

- HTTP and WebSocket signaling run on the local server.
- Media is peer-to-peer WebRTC unless local TURN relay mode is used.
- SSH forwarding protects access to the local HTTP app.
- Exposing port `4000` to untrusted networks is not supported without authentication.

## Current Hardening Priorities

- Add optional room tokens.
- Add host allowlist configuration.
- Add rate limits for WebSocket connects.
- Add HTTPS guidance for non-localhost camera permissions.

