defmodule ZiosPizza.ProcessManager do
  use GenServer
  alias ZiosPizza.Carts.Gateway, as: CartGateway
  alias ZiosPizza.Scheduler.Gateway, as: SchedulerGateway
  alias ZiosPizza.Slots.Gateway, as: SlotGateway
  alias ZiosPizza.Utils.Functions

  @minutes_to_deliver_a_pizza 15

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

  def handle_info({:order_created, order}, state) do
    :ok = CartGateway.execute(order.user_id, :stop_cart)
    scheduled_time = Functions.subtract_minutes(order.reserved_slot, @minutes_to_deliver_a_pizza)
    {:ok, _} = SchedulerGateway.schedule(scheduled_time, order)

    {:noreply, state}
  end
end
