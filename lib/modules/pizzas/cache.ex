defmodule ZiosPizza.Pizzas.Cache do
  use GenServer
  alias ZiosPizza.Pizzas.Repo

  @refresh_interval 1000 * 60 * 15

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get(id) do
    GenServer.call(__MODULE__, {:get_pizza, id})
  end

  def get_all do
    GenServer.call(__MODULE__, :get_all)
  end

  def init([]) do
    {:ok, [], {:continue, :load}}
  end

  def handle_call({:get_pizza, id}, _from, state) do
    case search(state, id) do
      {pizzas, nil} -> {:reply, :not_found, pizzas}
      {pizzas, pizza} -> {:reply, {:ok, pizza}, pizzas}
    end
  end

  def handle_call(:get_all, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_continue(:load, _state) do
    Process.send_after(self(), :refresh, @refresh_interval)
    {:noreply, Repo.get_all()}
  end

  def handle_info(:refresh, _state) do
    Process.send_after(self(), :refresh, @refresh_interval)
    {:noreply, Repo.get_all()}
  end

  defp search(list, id) do
    case search_in_memory(list, id) do
      {_, nil} -> search_on_db(id)
      {pizzas, pizza} -> {pizzas, pizza}
    end
  end

  defp search_in_memory(list, id) do
    {list, Enum.find(list, fn x -> x.id == id end)}
  end

  defp search_on_db(id) do
    pizzas = Repo.get_all()
    {pizzas, Enum.find(pizzas, fn x -> x.id == id end)}
  end
end
