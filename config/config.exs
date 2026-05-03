import Config

config :vcex,
  host: {0, 0, 0, 0},
  port: 4000,
  public_dir: "public",
  start_server: true

env_config = "#{config_env()}.exs"

if File.exists?(Path.join(__DIR__, env_config)) do
  import_config env_config
end
