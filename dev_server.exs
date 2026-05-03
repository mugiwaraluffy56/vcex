Kernel.ParallelCompiler.compile(Path.wildcard("lib/**/*.ex"), return_diagnostics: true)

Application.put_env(:lan_call, :port, 4000)
Application.put_env(:lan_call, :host, {0, 0, 0, 0})
Application.put_env(:lan_call, :public_dir, "public")

{:ok, _room} = LanCall.Room.start_link([])
{:ok, _pid} = LanCall.Server.start_link([])
LanCall.Banner.print(4000)
Process.sleep(:infinity)
