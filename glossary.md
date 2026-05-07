# Glossary

## WebRTC

Browser technology for peer-to-peer audio, video, and data channels.

## Signaling

The message exchange used to coordinate a WebRTC connection. vcex relays signaling over WebSocket.

## ICE

Interactive Connectivity Establishment. WebRTC uses ICE to find a media path between peers.

## STUN

A server that helps peers discover public-facing network addresses. vcex avoids public STUN by default.

## TURN

A relay server used when direct peer-to-peer media cannot connect. vcex documents local TURN as a fallback.

## Room

A logical call space where peers exchange signaling messages.

