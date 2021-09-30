defmodule ZiosPizza.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: ZiosPizza.Router, options: [port: 4000]},
      {ZiosPizza.Kitchen.Pooler, [10]},
      ZiosPizza.Repo,
      {Registry, [keys: :duplicate, name: ZiosPizza.PubSub.Registry]},
      {ZiosPizza.Pizzas.Cache, []},
      {Registry, [keys: :unique, name: ZiosPizza.Carts.Registry]},
      {Registry, [keys: :unique, name: ZiosPizza.Slots.Registry]},
      {Registry, [keys: :unique, name: ZiosPizza.Orders.Registry]},
      {Registry, [keys: :unique, name: ZiosPizza.Scheduler.Registry]},
      {Registry, [keys: :unique, name: ZiosPizza.Pizzaiolo.Registry]},
      {ZiosPizza.ProcessManager, []},
      {ZiosPizza.Carts.Gateway, []},
      {ZiosPizza.Slots.Gateway, []},
      {ZiosPizza.Orders.Gateway, []},
      {ZiosPizza.Scheduler.Gateway, []},
      {ZiosPizza.Kitchen.Gateway, []}
    ]

    opts = [strategy: :one_for_one, name: ZiosPizza.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
