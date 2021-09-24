defmodule ZiosPizza.Kitchen.Pizzaiolo do
  use GenServer
  alias ZiosPizza.Broker
  alias ZiosPizza.Kitchen.Pooler

  @prepare_time Application.get_env(:zios_pizza, :prepare_time)

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def init(name) do
    {:ok, name}
  end

  def prepare_order(name, order) do
    GenServer.cast(via_tuple(name), {:prepare_order, order})
  end

  def handle_cast({:prepare_order, order}, state) do
    # simulate long process
    Process.sleep(Enum.random(@prepare_time))
    Broker.publish({:order_ready, Map.put(order, :pizzaiolo, state)})
    Pooler.check_out(state)
    {:noreply, state}
  end

  defp via_tuple(name) do
    {:via, Registry, {ZiosPizza.Pizzaiolo.Registry, name}}
  end
end
