defmodule ZiosPizza.Kitchen.Pooler do
  use GenServer

  def start_link([count]) do
    GenServer.start_link(__MODULE__, count, name: __MODULE__)
  end

  def init(count) do
    {:ok, count, {:continue, :init_pool}}
  end

  def handle_continue(:init_pool, initial_state) do
    children_name = Enum.map(1..initial_state, &"pizzaiolo_#{&1}")

    children =
      Enum.map(children_name, fn n ->
        %{id: n, start: {ZiosPizza.Kitchen.Pizzaiolo, :start_link, [n]}}
      end)

    new_state = Enum.map(children_name, fn n -> {n, :ready} end)

    {:ok, _} = Supervisor.start_link(ZiosPizza.Kitchen.PoolSupervisor, children)

    {:noreply, new_state}
  end

  def check_in do
    GenServer.call(__MODULE__, :check_in)
  end

  def check_out(pizzaiolo) do
    GenServer.call(__MODULE__, {:check_out, pizzaiolo})
  end

  def handle_call(:check_in, _from, state) do
    case Enum.find(state, fn {_, status} -> status == :ready end) do
      {name, :ready} ->
        pizzaioli = set_busy(state, name, [])
        {:reply, {:ok, name}, pizzaioli}

      _ ->
        {:reply, {:ko, "busy"}, state}
    end
  end

  def handle_call({:check_out, name}, _from, state) do
    pizzaioli = set_ready(state, name, [])
    {:reply, {:ok, pizzaioli}, pizzaioli}
  end

  defp set_busy([{name, :ready} | pizzaioli], current, list) when current == name do
    [{name, :busy} | pizzaioli ++ list]
  end

  defp set_busy([{name, status} | pizzaioli], current, list) do
    set_busy(pizzaioli, current, list ++ [{name, status}])
  end

  defp set_ready([{name, :busy} | pizzaioli], current, list) when current == name do
    [{name, :ready} | pizzaioli ++ list]
  end

  defp set_ready([{name, status} | pizzaioli], current, list) do
    set_ready(pizzaioli, current, list ++ [{name, status}])
  end
end
