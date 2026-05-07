# ADR 0003: Tauri Desktop Shell

## Status

Accepted.

## Context

The app should have a desktop path without replacing the browser fallback.

## Decision

Use Tauri for the native shell and keep browser assets available for fallback and testing.

## Consequences

- Desktop packaging can evolve separately.
- Browser behavior remains the source of truth for WebRTC compatibility.
- Rust and Node toolchains are required only for desktop work.

