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

  defp via_tuple(user_id) do
    {:via, Registry, {ZiosPizza.Carts.Registry, user_id}}
  end
end
