Kernel.ParallelCompiler.compile(Path.wildcard("lib/**/*.ex"), return_diagnostics: true)

port =
  System.argv()
  |> List.first()
  |> case do
    nil -> 4000
    value -> String.to_integer(value)
  end

Application.put_env(:lan_call, :port, port)
Application.put_env(:lan_call, :host, {0, 0, 0, 0})
Application.put_env(:lan_call, :public_dir, "public")

{:ok, _room} = LanCall.Room.start_link([])
{:ok, _pid} = LanCall.Server.start_link(port: port)
LanCall.Banner.print(port)
Process.sleep(:infinity)
