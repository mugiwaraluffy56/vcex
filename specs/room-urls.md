# Room URLs Spec

## Goal

Allow users to join stable rooms from URLs.

## Proposed URL

```text
http://localhost:4000/r/:room
```

## Behavior

- Room name is parsed from the path.
- Empty room falls back to `default`.
- Invite copy uses the current origin and room.
- Room names are normalized to safe characters.

