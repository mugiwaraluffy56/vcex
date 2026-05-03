defmodule LanCall.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children =
      if Application.get_env(:lan_call, :start_server, true) do
        [LanCall.Room, LanCall.Server]
      else
        []
      end

    Supervisor.start_link(children, strategy: :one_for_one, name: LanCall.Supervisor)
  end
end
