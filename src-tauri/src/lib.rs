use serde::Serialize;
use std::{
    net::{TcpStream, UdpSocket},
    path::PathBuf,
    process::{Child, Command, Stdio},
    sync::Mutex,
    thread,
    time::Duration,
};
use tauri::{Manager, State};

#[derive(Default)]
struct HostProcesses {
    children: Mutex<Vec<Child>>,
}

#[derive(Serialize)]
struct HostInfo {
    local_url: String,
    lan_url: String,
}

#[tauri::command]
fn start_host(state: State<HostProcesses>) -> Result<HostInfo, String> {
    let root = repo_root()?;
    let mut children = state.children.lock().map_err(|_| "process lock failed")?;

    if !port_open(3478) {
        children.push(spawn(&root, "elixir", &["start_turn.exs"])?);
        thread::sleep(Duration::from_millis(700));
    }

    if !port_open(4000) {
        children.push(spawn(&root, "mix", &["run", "--no-halt"])?);
        thread::sleep(Duration::from_millis(900));
    }

    let ip = local_ip();

    Ok(HostInfo {
        local_url: "http://localhost:4000".to_string(),
        lan_url: format!("http://{ip}:4000"),
    })
}

fn port_open(port: u16) -> bool {
    TcpStream::connect(("127.0.0.1", port)).is_ok()
}

fn spawn(root: &PathBuf, program: &str, args: &[&str]) -> Result<Child, String> {
    Command::new(program)
        .args(args)
        .current_dir(root)
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .spawn()
        .map_err(|error| format!("failed to start {program}: {error}"))
}

fn repo_root() -> Result<PathBuf, String> {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    manifest_dir
        .parent()
        .map(PathBuf::from)
        .ok_or_else(|| "repo root not found".to_string())
}

fn local_ip() -> String {
    UdpSocket::bind("0.0.0.0:0")
        .and_then(|socket| {
            socket.connect("8.8.8.8:80")?;
            socket.local_addr()
        })
        .map(|addr| addr.ip().to_string())
        .unwrap_or_else(|_| "127.0.0.1".to_string())
}

pub fn run() {
    tauri::Builder::default()
        .manage(HostProcesses::default())
        .invoke_handler(tauri::generate_handler![start_host])
        .setup(|app| {
            let window = app.get_webview_window("main");

            if window.is_none() {
                return Err("main window not created".into());
            }

            Ok(())
        })
        .on_window_event(|window, event| {
            if matches!(event, tauri::WindowEvent::Destroyed) {
                if let Some(state) = window.try_state::<HostProcesses>() {
                    if let Ok(mut children) = state.children.lock() {
                        for child in children.iter_mut() {
                            let _ = child.kill();
                        }
                        children.clear();
                    }
                }
            }
        })
        .run(tauri::generate_context!())
        .expect("error while running vcex desktop app");
}
