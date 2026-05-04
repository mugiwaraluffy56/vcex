# Native Desktop App

vcex includes a Tauri desktop launcher.

## Requirements

```bash
npm install
```

## Run

```bash
npm run desktop:dev
```

## Host

Click `Start host`.

The native app starts:

- local TURN relay on `3478`
- Elixir signaling server on `4000`

Then it opens:

```text
http://localhost:4000
```

Share the LAN URL shown in the launcher, for example:

```text
http://10.110.154.203:4000
```

## Join

Enter the host URL and click `Join`.

If using SSH tunnel, join `http://localhost:4000`.

## Build

```bash
npm run desktop:build
```

macOS camera and microphone permission strings are configured in `src-tauri/tauri.conf.json`.
