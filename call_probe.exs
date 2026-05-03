target = List.first(System.argv()) || "127.0.0.1"
port = 4000

case :gen_tcp.connect(String.to_charlist(target), port, [:binary, active: false], 2_000) do
  {:ok, socket} ->
    :ok = :gen_tcp.close(socket)
    IO.puts("ok: #{target}:#{port} reachable")

  {:error, reason} ->
    IO.puts("fail: #{target}:#{port} #{inspect(reason)}")
    System.halt(1)
end
