defmodule ZiosPizza.Kitchen.Pizzaiolo do
  use GenServer
  alias ZiosPizza.Broker

  @prepare_time Application.get_env(:zios_pizza, :prepare_time)

  def start_link(name) do
    GenServer.start_link(__MODULE__, name)
  end

  def init(name) do
    {:ok, name}
  end

  def prepare_order(pid, order) do
    GenServer.cast(pid, {:prepare_order, order})
  end

  def handle_cast({:prepare_order, order}, state) do
    # simulate long process
    Process.sleep(Enum.random(@prepare_time))
    Broker.publish({:order_ready, Map.put(order, :pizzaiolo, self())})
    :poolboy.checkin(:pizzaiolo_worker, self())
    {:noreply, state}
  end
end
