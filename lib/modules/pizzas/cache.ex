defmodule ZiosPizza.Pizzas.Cache do
  use GenServer

  # TODO
  # - all'avvio caricare elenco pizze
  # - funzione per recupero pizze da parte del client
  # - meccanismo di refresh della cache


  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    {:ok, [], {:continue, :load_pizzas}}
  end

  def handle_continue(:load_pizzas, state) do
    ## caricamento pizze
    {:noreply, state}
  end

  def load_pizzas do
    GenServer.call(__MODULE__, :get_pizzas)
  end

  def handle_call(:get_pizzas, _from, state) do
    {:reply, state, state}
  end

end
