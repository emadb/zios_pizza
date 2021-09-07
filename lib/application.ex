defmodule ZiosPizza.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: ZiosPizza.Router, options: [port: 4000]},
      ZiosPizza.Repo,
      {ZiosPizza.Pizzas.Cache, []}
    ]

    opts = [strategy: :one_for_one, name: ZiosPizza.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
