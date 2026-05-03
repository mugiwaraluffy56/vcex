defmodule Vcex.Server do
  use GenServer
  require Logger

  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)

  @impl true
  def init(opts) do
    host = Keyword.get(opts, :host, Application.get_env(:vcex, :host, {0, 0, 0, 0}))
    port = Keyword.get(opts, :port, configured_port())

    case :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true, ip: host]) do
      {:ok, socket} ->
        send(self(), :accept)
        {:ok, %{socket: socket, port: port}}

      {:error, :eaddrinuse} ->
        {:stop, {:port_in_use, port}}

      {:error, reason} ->
        {:stop, {:listen_failed, port, reason}}
    end
  end

  defp configured_port do
    case System.get_env("PORT") do
      nil -> Application.get_env(:vcex, :port, 4000)
      value -> String.to_integer(value)
    end
  end

  @impl true
  def handle_info(:accept, state) do
    {:ok, client} = :gen_tcp.accept(state.socket)
    pid = spawn_link(fn -> wait_for_socket() end)
    :ok = :gen_tcp.controlling_process(client, pid)
    send(pid, {:socket, client})
    send(self(), :accept)
    {:noreply, state}
  end

  defp wait_for_socket do
    receive do
      {:socket, socket} -> handle_client(socket)
    end
  end

  defp handle_client(socket) do
    case :gen_tcp.recv(socket, 0, 5_000) do
      {:ok, request} -> route(socket, Vcex.HTTP.parse(request))
      {:error, _reason} -> :gen_tcp.close(socket)
    end
  rescue
    error ->
      Logger.error("client error: #{inspect(error)}")
      :gen_tcp.close(socket)
  end

  defp route(socket, %{path: "/ws", headers: headers}) do
    if String.downcase(Map.get(headers, "upgrade", "")) == "websocket" do
      :ok = :gen_tcp.send(socket, Vcex.WebSocket.handshake(headers))
      :ok = Vcex.Room.join(self())
      ws_loop(socket, <<>>)
    else
      send_response(socket, 426, "text/plain", "websocket required")
    end
  end

  defp route(socket, %{path: "/health"}), do: send_response(socket, 200, "text/plain", "ok")
  defp route(socket, %{path: "/"}), do: serve_file(socket, "index.html")
  defp route(socket, %{path: path}), do: serve_file(socket, String.trim_leading(path, "/"))

  defp serve_file(socket, path) do
    public_dir = Application.get_env(:vcex, :public_dir, "public")
    safe_path = path |> String.split("/") |> Enum.reject(&(&1 in ["", ".", ".."])) |> Path.join()
    file = Path.join(public_dir, safe_path)

    case File.read(file) do
      {:ok, body} -> send_response(socket, 200, Vcex.HTTP.mime(file), body)
      {:error, _reason} -> send_response(socket, 404, "text/plain", "not found")
    end
  end

  defp send_response(socket, status, content_type, body) do
    :gen_tcp.send(socket, Vcex.HTTP.response(status, content_type, body))
    :gen_tcp.close(socket)
  end

  defp ws_loop(socket, buffer) do
    :inet.setopts(socket, active: :once)

    receive do
      {:tcp, ^socket, frame} ->
        ws_loop(socket, drain_frames(buffer <> frame))

      {:ws_send, payload} ->
        :gen_tcp.send(socket, Vcex.WebSocket.encode_text(payload))
        ws_loop(socket, buffer)

      {:peer_count, count} ->
        :gen_tcp.send(
          socket,
          Vcex.WebSocket.encode_text(~s({"type":"peer-count","count":#{count}}))
        )

        ws_loop(socket, buffer)

      {:tcp_closed, ^socket} ->
        Vcex.Room.leave(self())

      {:tcp_error, ^socket, _reason} ->
        Vcex.Room.leave(self())
    after
      120_000 ->
        :gen_tcp.close(socket)
        Vcex.Room.leave(self())
    end
  end

  defp drain_frames(buffer) do
    case Vcex.WebSocket.decode_frame(buffer) do
      {:ok, 1, payload, rest} ->
        Vcex.Room.relay(self(), payload)
        drain_frames(rest)

      {:ok, 8, _payload, rest} ->
        Vcex.Room.leave(self())
        rest

      {:ok, _opcode, _payload, rest} ->
        drain_frames(rest)

      :more ->
        buffer

      {:error, _reason} ->
        <<>>
    end
  end
end
