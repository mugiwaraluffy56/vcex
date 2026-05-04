use tauri::{WebviewUrl, WebviewWindowBuilder};
use url::Url;

const DEFAULT_URL: &str = "http://localhost:4000";

pub fn run() {
    tauri::Builder::default()
        .setup(|app| {
            let url = std::env::var("VCEX_URL").unwrap_or_else(|_| DEFAULT_URL.to_string());
            let url = Url::parse(&url).map_err(|error| format!("invalid VCEX_URL: {error}"))?;

            WebviewWindowBuilder::new(app, "main", WebviewUrl::External(url))
                .title("vcex")
                .inner_size(1180.0, 760.0)
                .min_inner_size(860.0, 560.0)
                .resizable(true)
                .build()?;

            Ok(())
        })
        .run(tauri::generate_context!())
        .expect("error while running vcex desktop app");
}
