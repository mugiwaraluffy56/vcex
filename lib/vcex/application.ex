defmodule Vcex.Application do
  use Application

  @impl true
  def start(_type, _args) do
    start_server? = Application.get_env(:vcex, :start_server, true)

    children =
      if start_server? do
        [Vcex.Room, Vcex.Server]
      else
        []
      end

    case Supervisor.start_link(children, strategy: :one_for_one, name: Vcex.Supervisor) do
      {:ok, _pid} = result ->
        if start_server? do
          Vcex.Banner.print(configured_port())
        end

        result

      {:error, {:shutdown, {:failed_to_start_child, Vcex.Server, {:port_in_use, port}}}} ->
        IO.puts("""
        Port #{port} already in use.

        Stop old server:
        lsof -tiTCP:#{port} -sTCP:LISTEN | xargs kill

        Or use another port:
        PORT=4050 mix run --no-halt
        """)

        {:error, {:port_in_use, port}}

      other ->
        other
    end
  end

  defp configured_port do
    case System.get_env("PORT") do
      nil -> Application.get_env(:vcex, :port, 4000)
      value -> String.to_integer(value)
    end
  end
end
