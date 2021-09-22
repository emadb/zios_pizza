defmodule ZiosPizza.Pizza.Router do
  use Plug.Router
  alias ZiosPizza.Pizza.Repo

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    term = Map.get(conn.query_params, "search", "")

    pizzas =
      Repo.search_by(term)
      |> map_pizza()
      |> Jason.encode!()

    send_resp(conn, 200, pizzas)
  end

  def map_pizza(pizzas) do
    Enum.map(pizzas, fn p ->
      %{id: p.id, name: p.name, price: p.price}
    end)
  end
end
