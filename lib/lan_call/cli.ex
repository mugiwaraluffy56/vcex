defmodule LanCall.CLI do
  def main(args) do
    port =
      args
      |> List.first()
      |> case do
        nil -> 4000
        value -> String.to_integer(value)
      end

    Application.put_env(:lan_call, :port, port)
    {:ok, _room} = LanCall.Room.start_link([])
    {:ok, _pid} = LanCall.Server.start_link(port: port)
    LanCall.Banner.print(port)
    Process.sleep(:infinity)
  end
end
