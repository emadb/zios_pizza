defmodule ZiosPizza.Orders.Server do
  use GenServer, restart: :transient
  alias ZiosPizza.Broker
  alias ZiosPizza.Orders.Order
  alias ZiosPizza.Orders.Repo

  @timeout Application.get_env(:zios_pizza, :process_timeout)

  def start_link([code] = args) do
    GenServer.start_link(__MODULE__, args, name: via_tuple(code))
  end

  def init([code]) do
    {:ok, Order.initial_state(code), {:continue, :load}}
  end

  defp via_tuple(code) do
    {:via, Registry, {ZiosPizza.Orders.Registry, code}}
  end

  def handle_continue(:load, state) do
    case Repo.get_by_code(state.code) do
      {:ok, order} ->
        {:noreply, order, @timeout}

      :not_found ->
        {:noreply, state, @timeout}
    end
  end

  def handle_info(:timeout, state) do
    {:stop, :shutdown, state}
  end

  def execute(code, cmd) do
    GenServer.call(via_tuple(code), cmd)
  end

  def handle_call({:create_order, payload}, _from, state) do
    order = Order.create(state, payload.cart)

    if Order.valid?(order) do
      Repo.upsert(order)

      # payment gateway for transaction

      Broker.publish({:order_created, order})
      {:reply, {:ok, order}, order, @timeout}
    else
      {:reply, {:error, "order not valid"}, state, @timeout}
    end
  end

  def handle_call({:set_ready, _}, _from, state) do
    order = Order.set_ready(state)
    Repo.upsert(order)
    {:reply, {:ok, order}, order, @timeout}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, {:ok, state}, state, @timeout}
  end
end
