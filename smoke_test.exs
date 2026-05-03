Kernel.ParallelCompiler.compile(Path.wildcard("lib/**/*.ex"), return_diagnostics: true)

{:ok, _room} = LanCall.Room.start_link([])
port = 41_000 + :rand.uniform(10_000)
{:ok, _pid} = LanCall.Server.start_link(port: port)

{:ok, socket} = :gen_tcp.connect(~c"127.0.0.1", port, [:binary, active: false])
:ok = :gen_tcp.send(socket, "GET /health HTTP/1.1\r\nhost: localhost\r\n\r\n")
{:ok, response} = :gen_tcp.recv(socket, 0, 2_000)
:ok = :gen_tcp.close(socket)

unless response =~ "200 OK" and response =~ "ok" do
  IO.puts(response)
  System.halt(1)
end

IO.puts("smoke ok")
