const startBtn = document.querySelector("#startBtn");
const callBtn = document.querySelector("#callBtn");
const hangupBtn = document.querySelector("#hangupBtn");
const statusEl = document.querySelector("#status");
const wsUrlEl = document.querySelector("#wsUrl");
const peerCountEl = document.querySelector("#peerCount");
const localVideo = document.querySelector("#localVideo");
const remoteVideo = document.querySelector("#remoteVideo");

let ws;
let pc;
let localStream;
let pendingCandidates = [];

const wsUrl = `${location.protocol === "https:" ? "wss" : "ws"}://${location.host}/ws`;
wsUrlEl.textContent = wsUrl;

const setStatus = (text) => {
  statusEl.textContent = text;
};

const fail = (error) => {
  console.error(error);
  setStatus(error.message || String(error));
};

const connectSocket = () => {
  ws = new WebSocket(wsUrl);

  ws.onopen = () => {
    setStatus("Signal connected");
    if (localStream) callBtn.disabled = false;
  };

  ws.onclose = () => setStatus("Signal closed");
  ws.onerror = () => setStatus("Signal error");
  ws.onmessage = async (event) => {
    try {
      const msg = JSON.parse(event.data);

      if (msg.type === "peer-count" || msg.type === "peer-joined" || msg.type === "peer-left") {
        peerCountEl.textContent = `peers: ${msg.count}`;
        return;
      }

      if (!pc) createPeer();

      if (msg.type === "offer") {
        await pc.setRemoteDescription(msg);
        await flushCandidates();
        const answer = await pc.createAnswer();
        await pc.setLocalDescription(answer);
        send(answer);
        setStatus("Answered");
      }

      if (msg.type === "answer") {
        await pc.setRemoteDescription(msg);
        await flushCandidates();
        setStatus("Connected");
      }

      if (msg.type === "candidate" && msg.candidate) {
        if (pc.remoteDescription) {
          await pc.addIceCandidate(msg.candidate);
        } else {
          pendingCandidates.push(msg.candidate);
        }
      }
    } catch (error) {
      fail(error);
    }
  };
};

const send = (payload) => {
  if (ws && ws.readyState === WebSocket.OPEN) {
    ws.send(JSON.stringify(payload));
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

const createPeer = () => {
  pc = new RTCPeerConnection({ iceServers: [] });

  pc.onicecandidate = (event) => {
    if (event.candidate) send({ type: "candidate", candidate: event.candidate });
  };

  pc.ontrack = (event) => {
    remoteVideo.srcObject = event.streams[0];
  };

  pc.onconnectionstatechange = () => {
    setStatus(`Peer ${pc.connectionState}`);
    hangupBtn.disabled = pc.connectionState === "closed";
  };

  if (localStream) {
    localStream.getTracks().forEach((track) => pc.addTrack(track, localStream));
  }

  return pc;
};

startBtn.onclick = async () => {
  try {
    startBtn.disabled = true;
    callBtn.disabled = true;
    connectSocket();
    localStream = await navigator.mediaDevices.getUserMedia({
      video: { width: 1280, height: 720, frameRate: 30 },
      audio: true
    });
    localVideo.srcObject = localStream;
    createPeer();
    hangupBtn.disabled = false;
    setStatus("Camera ready, waiting signal");
  } catch (error) {
    startBtn.disabled = false;
    fail(error);
  }
};

callBtn.onclick = async () => {
  try {
    callBtn.disabled = true;
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
