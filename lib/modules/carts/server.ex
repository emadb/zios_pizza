defmodule ZiosPizza.Carts.Server do
  use GenServer, restart: :transient
  alias ZiosPizza.Carts.Cart

  def start_link([user_id] = args) do
    GenServer.start_link(__MODULE__, args, name: via_tuple(user_id))
  end

  def init([user_id]) do
    {:ok, Cart.initial_state(user_id)}
  end

  def execute(user_id, cmd) do
    GenServer.call(via_tuple(user_id), cmd)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:add_pizza, item}, _from, state) do
    new_state = Cart.add_pizza(state, item)
    {:reply, {:ok, new_state}, new_state}
  end

  def handle_call({:set_slot, payload}, _from, state) do
    new_state = Cart.set_slot(state, payload)
    set_slot_timeout(new_state.reserved_slot)
    {:reply, {:ok, new_state}, new_state}
  end

  def handle_call(:stop_cart, _from, state) do
    {:stop, :shutdown, :ok, state}
  end

  def handle_info(:verify_slot_status, state) do
    new_state = Cart.release_slot(state)

    ZiosPizza.Broker.publish(
      {:release_slot, %{user_id: state.user_id, datetime: state.reserved_slot}}
    )

    {:noreply, new_state}
  end

  defp set_slot_timeout(nil), do: :ok

  defp set_slot_timeout(_) do
    Process.send_after(self(), :verify_slot_status, 1000 * 60 * 10)
    :ok
  end

  defp via_tuple(user_id) do
    {:via, Registry, {ZiosPizza.Carts.Registry, user_id}}
  end
end
