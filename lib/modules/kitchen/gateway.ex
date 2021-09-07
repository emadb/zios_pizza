defmodule ZiosPizza.Kitchen.Gateway do
  use GenServer

  alias ZiosPizza.Kitchen.Pizzaiolo

  def start_link(_) do
    {:ok, _} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, 0}
  end

  def prepare_pizzas(order) do
    GenServer.cast(__MODULE__, {:prepare_pizzas, order})
  end

  def handle_cast({:prepare_pizzas, order}, state) do
    pizzaiolo = :poolboy.checkout(:pizziolo_worker)
    Pizzaiolo.prepare_order(pizzaiolo, order)
    {:noreply, state + 1}
  end
end
