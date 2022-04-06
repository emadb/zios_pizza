defmodule ZiosPizza.Cart.Gateway do
  use DynamicSupervisor

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def execute(id, cmd) do
    # Il carrello id esiste?
    # si -> passo il comando
    # no -> avvio l'attore e passo il comando
    DynamicSupervisor.start_child(__MODULE__, {ZiosPizza.Cart.Server, id})
    ZiosPizza.Cart.Server.execute(id, cmd)
  end
end
