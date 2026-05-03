const startBtn = document.querySelector("#startBtn");
const callBtn = document.querySelector("#callBtn");
const hangupBtn = document.querySelector("#hangupBtn");
const statusEl = document.querySelector("#status");
const wsUrlEl = document.querySelector("#wsUrl");
const peerCountEl = document.querySelector("#peerCount");
const localVideo = document.querySelector("#localVideo");
const remoteVideo = document.querySelector("#remoteVideo");
const logEl = document.querySelector("#log");
const incomingModal = document.querySelector("#incomingModal");
const acceptBtn = document.querySelector("#acceptBtn");
const declineBtn = document.querySelector("#declineBtn");

let ws;
let pc;
let localStream;
let pendingCandidates = [];
let wsReadyResolve;
let wsReadyReject;
let incomingOffer;
let rtcConfig = { iceServers: [], iceTransportPolicy: "all" };

const wsUrl = `${location.protocol === "https:" ? "wss" : "ws"}://${location.host}/ws`;
wsUrlEl.textContent = wsUrl;

const setStatus = (text) => {
  statusEl.textContent = text;
};

const log = (text) => {
  const time = new Date().toLocaleTimeString();
  logEl.textContent = `${time} ${text}\n${logEl.textContent}`.slice(0, 3000);
};

const fail = (error) => {
  console.error(error);
  setStatus(error.message || String(error));
  log(`error: ${error.message || String(error)}`);
};

const refreshControls = () => {
  const signalReady = ws && ws.readyState === WebSocket.OPEN;
  const cameraReady = Boolean(localStream);
  callBtn.disabled = !(signalReady && cameraReady);
  hangupBtn.disabled = !cameraReady;
};

const showIncoming = (offer) => {
  incomingOffer = offer;
  incomingModal.hidden = false;
  setStatus("Incoming call");
  log("incoming call");
};

const hideIncoming = () => {
  incomingModal.hidden = true;
  incomingOffer = null;
};

const connectSocket = () => {
  if (ws && (ws.readyState === WebSocket.OPEN || ws.readyState === WebSocket.CONNECTING)) {
    return;
  }

  ws = new WebSocket(wsUrl);

  ws.onopen = () => {
    setStatus("Signal connected");
    log("signal connected");
    refreshControls();
    if (wsReadyResolve) wsReadyResolve();
  };

  ws.onclose = () => {
    setStatus("Signal closed");
    log("signal closed");
    refreshControls();
  };

  ws.onerror = () => {
    setStatus("Signal error");
    log("signal error");
    if (wsReadyReject) wsReadyReject(new Error("Signal error"));
  };

  ws.onmessage = async (event) => {
    try {
      const msg = JSON.parse(event.data);

      if (msg.type === "peer-count" || msg.type === "peer-joined" || msg.type === "peer-left") {
        peerCountEl.textContent = `peers: ${msg.count}`;
        log(`${msg.type}: ${msg.count}`);
        return;
      }

      if (!pc) createPeer();

      if (msg.type === "offer") {
        log("offer received");
        showIncoming(msg);
      }

      if (msg.type === "answer") {
        log("answer received");
        await pc.setRemoteDescription(msg);
        await flushCandidates();
        setStatus("Connected");
      }

      if (msg.type === "decline") {
        setStatus("Call declined");
        log("call declined");
        callBtn.disabled = false;
      }

      if (msg.type === "candidate" && msg.candidate) {
        if (pc.remoteDescription) {
          await pc.addIceCandidate(msg.candidate);
          log("candidate added");
        } else {
          pendingCandidates.push(msg.candidate);
          log("candidate queued");
        }
      }
    } catch (error) {
      fail(error);
    }
  };
};

const waitForSignal = () => {
  if (ws && ws.readyState === WebSocket.OPEN) return Promise.resolve();

  connectSocket();

  return new Promise((resolve, reject) => {
    wsReadyResolve = resolve;
    wsReadyReject = reject;
    window.setTimeout(() => reject(new Error("Signal timeout")), 5000);
  });
};

const send = (payload) => {
  if (ws && ws.readyState === WebSocket.OPEN) {
    ws.send(JSON.stringify(payload));
    log(`${payload.type} sent`);
    return true;
  }

  setStatus("Signal not ready");
  return false;
};

const flushCandidates = async () => {
  while (pendingCandidates.length > 0) {
    await pc.addIceCandidate(pendingCandidates.shift());
  }
};

const loadRtcConfig = async () => {
  const response = await fetch("/config.json", { cache: "no-store" });
  rtcConfig = await response.json();
  log(`ice policy ${rtcConfig.iceTransportPolicy}`);
};

const tuneSender = async (sender) => {
  if (!sender.track || sender.track.kind !== "video" || !sender.getParameters) return;

  const params = sender.getParameters();
  params.encodings = params.encodings && params.encodings.length > 0 ? params.encodings : [{}];
  params.encodings[0].maxBitrate = 8_000_000;
  params.encodings[0].maxFramerate = 60;
  params.encodings[0].scaleResolutionDownBy = 1;
  await sender.setParameters(params);
};

const createPeer = () => {
  pc = new RTCPeerConnection(rtcConfig);

  pc.onicecandidate = (event) => {
    if (event.candidate) send({ type: "candidate", candidate: event.candidate });
  };

  pc.ontrack = (event) => {
  const [stream] = event.streams;

  if (remoteVideo.srcObject !== stream) {
    remoteVideo.srcObject = stream;
  }

  remoteVideo.muted = false;

  if (event.track.kind === "video") {
    remoteVideo
      .play()
      .then(() => log("remote video playing"))
      .catch((error) => {
        log(`remote play blocked: ${error.message}`);
        setStatus("Click remote video to play");
      });
  }

  log(`remote ${event.track.kind} track received`);
};

  pc.onconnectionstatechange = () => {
    setStatus(`Peer ${pc.connectionState}`);
    log(`peer ${pc.connectionState}`);
    hangupBtn.disabled = pc.connectionState === "closed";
  };

  pc.oniceconnectionstatechange = () => {
    log(`ice ${pc.iceConnectionState}`);

    if (pc.iceConnectionState === "failed" || pc.iceConnectionState === "disconnected") {
      setStatus(`ICE ${pc.iceConnectionState}`);
    }
  };

  pc.onicegatheringstatechange = () => {
    log(`ice gathering ${pc.iceGatheringState}`);
  };

  if (localStream) {
    localStream.getTracks().forEach((track) => {
      track.contentHint = track.kind === "video" ? "motion" : "speech";
      const sender = pc.addTrack(track, localStream);
      tuneSender(sender).catch(fail);
    });
  }

  return pc;
};

const acceptIncoming = async () => {
  if (!incomingOffer) return;
  if (!pc) createPeer();

  if (pc.signalingState !== "stable") {
    await pc.setLocalDescription({ type: "rollback" });
    log("local offer rolled back");
  }

  await pc.setRemoteDescription(incomingOffer);
  await flushCandidates();
  const answer = await pc.createAnswer();
  await pc.setLocalDescription(answer);
  send(answer);
  hideIncoming();
  setStatus("Answered");
  log("answer sent");
};

const declineIncoming = () => {
  send({ type: "decline" });
  hideIncoming();
  setStatus("Call declined");
  log("incoming declined");
};

startBtn.onclick = async () => {
  try {
    startBtn.disabled = true;
    callBtn.disabled = true;
    connectSocket();
    await loadRtcConfig();
    const signalReady = waitForSignal();
    localStream = await navigator.mediaDevices.getUserMedia({
      video: {
        width: { ideal: 1920 },
        height: { ideal: 1080 },
        frameRate: { ideal: 60, max: 60 }
      },
      audio: true
    });
    localVideo.srcObject = localStream;
    log("camera ready");
    createPeer();
    await signalReady;
    refreshControls();
    setStatus("Ready");
  } catch (error) {
    startBtn.disabled = false;
    refreshControls();
    fail(error);
  }
};

callBtn.onclick = async () => {
  try {
    callBtn.disabled = true;
    await waitForSignal();
    if (!pc) createPeer();
    const offer = await pc.createOffer();
    await pc.setLocalDescription(offer);

    if (send(offer)) {
      setStatus("Calling");
    } else {
      callBtn.disabled = false;
    }
  } catch (error) {
    callBtn.disabled = false;
    fail(error);
  }
};

hangupBtn.onclick = () => {
  if (pc) pc.close();
  pc = null;
  remoteVideo.srcObject = null;
  hangupBtn.disabled = true;
  callBtn.disabled = !(ws && ws.readyState === WebSocket.OPEN && localStream);
  setStatus("Hung up");
};

remoteVideo.onclick = () => {
  remoteVideo.play().catch(fail);
};

acceptBtn.onclick = () => {
  acceptIncoming().catch(fail);
};

declineBtn.onclick = declineIncoming;
