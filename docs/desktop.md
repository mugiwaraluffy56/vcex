# Native Desktop App

vcex includes a Tauri desktop shell. It loads the running vcex web server in a native window.

## Requirements

```bash
npm install
```

## Run Services

Terminal 1:

```bash
elixir start_turn.exs
```

Terminal 2:

```bash
mix run --no-halt
```

## Run Desktop App

Terminal 3:

```bash
npm run desktop:dev
```

The default app URL is:

```text
http://localhost:4000
```

Override it with:

```bash
VCEX_URL=http://10.110.154.203:4000 npm run desktop:dev
```

## Build

```bash
npm run desktop:build
```

macOS camera and microphone permission strings are configured in `src-tauri/tauri.conf.json`.
