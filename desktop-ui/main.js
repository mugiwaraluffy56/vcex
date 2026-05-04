const hostBtn = document.querySelector("#hostBtn");
const joinBtn = document.querySelector("#joinBtn");
const hostUrlEl = document.querySelector("#hostUrl");
const joinUrlEl = document.querySelector("#joinUrl");
const logEl = document.querySelector("#log");

const log = (message) => {
  const time = new Date().toLocaleTimeString();
  logEl.textContent = `${time} ${message}\n${logEl.textContent}`.slice(0, 3000);
};

hostBtn.onclick = async () => {
    hostBtn.disabled = true;
  try {
    log("starting host services");
    const info = await window.__TAURI__.core.invoke("start_host");
    hostUrlEl.textContent = info.lan_url;
    joinUrlEl.value = info.local_url;
    log(`host ready: ${info.lan_url}`);
    window.location.href = info.local_url;
  } catch (error) {
    hostBtn.disabled = false;
    log(`error: ${error}`);
  }
};

joinBtn.onclick = () => {
  const value = joinUrlEl.value.trim();
  if (!value) return;
  const url = value.startsWith("http") ? value : `http://${value}:4000`;
  log(`joining ${url}`);
  window.location.href = url;
};
