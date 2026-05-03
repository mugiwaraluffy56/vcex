defmodule Vcex.Room do
  use GenServer

  def start_link(_opts), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def join(pid), do: GenServer.call(__MODULE__, {:join, pid})
  def leave(pid), do: GenServer.cast(__MODULE__, {:leave, pid})
  def relay(from, payload), do: GenServer.cast(__MODULE__, {:relay, from, payload})

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call({:join, pid}, _from, state) do
    Process.monitor(pid)
    peers = Map.put(state, pid, true)
    send(pid, {:peer_count, map_size(peers)})
    broadcast(pid, ~s({"type":"peer-joined","count":#{map_size(peers)}}), peers)
    {:reply, :ok, peers}
  end

  @impl true
  def handle_cast({:leave, pid}, state), do: {:noreply, drop(pid, state)}

  @impl true
  def handle_cast({:relay, from, payload}, state) do
    broadcast(from, payload, state)
    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, pid, _reason}, state), do: {:noreply, drop(pid, state)}

  defp drop(pid, state) do
    peers = Map.delete(state, pid)
    broadcast(pid, ~s({"type":"peer-left","count":#{map_size(peers)}}), peers)
    peers
  end

  defp broadcast(from, payload, peers) do
    peers
    |> Map.keys()
    |> Enum.reject(&(&1 == from))
    |> Enum.each(&send(&1, {:ws_send, payload}))
  end
end
