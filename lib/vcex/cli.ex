defmodule Vcex.CLI do
  def main(args) do
    port =
      args
      |> List.first()
      |> case do
        nil -> 4000
        value -> String.to_integer(value)
      end

    Application.put_env(:vcex, :port, port)
    {:ok, _room} = Vcex.Room.start_link([])
    {:ok, _pid} = Vcex.Server.start_link(port: port)
    Vcex.Banner.print(port)
    Process.sleep(:infinity)
  end
end
