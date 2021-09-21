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
    pizzas =
      Repo.get_all()
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
