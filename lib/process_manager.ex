defmodule ZiosPizza.ProcessManager do
  use GenServer
  alias ZiosPizza.Carts.Gateway, as: CartGateway
  alias ZiosPizza.Slots.Gateway, as: SlotGateway

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    _ = ZiosPizza.Broker.subscribe()
    {:ok, []}
  end

  def handle_info({:slot_reserved, %{user_id: user_id, datetime: datetime}}, state) do
    CartGateway.execute(user_id, {:set_slot, %{datetime: datetime}})
    {:noreply, state}
  end

  def handle_info({:release_slot, %{user_id: user_id, datetime: datetime}}, state) do
    SlotGateway.execute(datetime, {:release_slot, %{user_id: user_id}})
    {:noreply, state}
  end
end
