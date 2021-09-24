defmodule ZiosPizza.Kitchen.Gateway do
  use GenServer

  alias ZiosPizza.Kitchen.Pizzaiolo
  alias ZiosPizza.Kitchen.Pooler

  @retry_count 100
  @retry_timeout 5000

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
    pizzaiolo = get_pizzaiolo(@retry_count)
    Pizzaiolo.prepare_order(pizzaiolo, order)
    {:noreply, state + 1}
  end

  defp get_pizzaiolo(0), do: :none_available

  defp get_pizzaiolo(retry) do
    case Pooler.check_in() do
      {:ko, _} ->
        Process.sleep(@retry_timeout)
        get_pizzaiolo(retry - 1)

      {:ok, pizzaiolo} ->
        pizzaiolo
    end
  end
end
