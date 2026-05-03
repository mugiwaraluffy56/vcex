Kernel.ParallelCompiler.compile(Path.wildcard("lib/**/*.ex"), return_diagnostics: true)

port =
  System.argv()
  |> List.first()
  |> case do
    nil -> 4000
    value -> String.to_integer(value)
  end

Application.put_env(:vcex, :port, port)
Application.put_env(:vcex, :host, {0, 0, 0, 0})
Application.put_env(:vcex, :public_dir, "public")

{:ok, _room} = Vcex.Room.start_link([])
{:ok, _pid} = Vcex.Server.start_link(port: port)
Vcex.Banner.print(port)
Process.sleep(:infinity)
