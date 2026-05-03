# Using vcex

## Requirements

- Elixir 1.19+ and Erlang/OTP 28+.
- Two browsers with WebRTC support.
- Both devices on the same LAN for direct media.
- Camera and microphone permission in the browser.

## Start the Host

From the repository root:

```bash
mix run --no-halt
```

The app listens on port `4000`.

Open on the host:

```text
http://localhost:4000
```

## Start a Local Test Call

1. Open `http://localhost:4000` in two browser tabs or windows.
2. Click `Start` in both tabs.
3. Click `Call` in one tab.
4. Remote video should appear in the other tab.

This tests signaling and WebRTC behavior on one machine.

## Use on LAN

Find the host machine IP:

```bash
ipconfig getifaddr en0
```

On the second device, open:

```text
http://HOST_LAN_IP:4000
```

Example:

```text
http://10.110.154.203:4000
```

Click `Start` on both devices, then click `Call` on one device.

## Use Through SSH

From the guest machine:

```bash
ssh -L 4000:localhost:4000 user@HOST_LAN_IP
```

Then open on the guest:

```text
http://localhost:4000
```

SSH forwards access to the web app and signaling server. WebRTC media still tries to use the direct LAN path for speed.

## Helpful Scripts

- `elixir dev_server.exs`: start the default server.
- `elixir call_host.exs 4000`: start on a chosen port.
- `elixir call_probe.exs HOST_LAN_IP`: check if port `4000` is reachable.
- `elixir smoke_test.exs`: run a quick server health check.
- `elixir ssh_tunnel.exs`: print SSH tunnel instructions.

## Troubleshooting

If camera access fails, use `localhost` or enable HTTPS later. Browsers allow camera access on `localhost`; plain LAN HTTP may be restricted by some browsers.

If the page loads but remote video stays blank, the LAN may block peer-to-peer WebRTC traffic. Try the same Wi-Fi network without guest isolation, or test with two tabs on the same machine.

If port `4000` is busy, stop the old server or start on another port:

```bash
PORT=4050 mix run --no-halt
```

You can also use:

```bash
elixir call_host.exs 4050
```

If SSH fails, enable Remote Login on the host machine and verify:

```bash
ssh user@HOST_LAN_IP
```

## Stop the Server

Press `Ctrl+C` twice in the terminal running the server.
