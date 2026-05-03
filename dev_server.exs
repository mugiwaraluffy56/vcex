Kernel.ParallelCompiler.compile(Path.wildcard("lib/**/*.ex"), return_diagnostics: true)

Application.put_env(:vcex, :port, 4000)
Application.put_env(:vcex, :host, {0, 0, 0, 0})
Application.put_env(:vcex, :public_dir, "public")

{:ok, _room} = Vcex.Room.start_link([])
{:ok, _pid} = Vcex.Server.start_link([])
Vcex.Banner.print(4000)
Process.sleep(:infinity)
