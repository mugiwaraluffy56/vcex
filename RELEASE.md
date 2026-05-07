# Release Process

vcex releases should prove that local, LAN, and desktop flows still work.

## Versioning

Use semantic versions:

- Patch: bug fixes and documentation.
- Minor: user-visible features.
- Major: protocol or compatibility breaks.

## Checklist

1. Update `VERSION`.
2. Update `CHANGELOG.md`.
3. Run `mix format --check-formatted`.
4. Run `mix test`.
5. Run `elixir smoke_test.exs`.
6. Run `npm run desktop:info` if desktop files changed.
7. Create a git tag.
8. Publish release notes with LAN/browser/desktop notes.

