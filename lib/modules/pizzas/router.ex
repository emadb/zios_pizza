defmodule ZiosPizza.Pizzas.Router do
  use Plug.Router
  alias ZiosPizza.Pizzas.Cache

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/:id" do
    with {id, ""} <- Integer.parse(id),
         {:ok, pizza} <- Cache.get(id) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(pizza))
    else
      :error ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{message: "bad id"}))

      :not_found ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{message: "pizza not found"}))
    end
  end

  get "/" do
    search = Map.get(conn.query_params, "search", "")

    pizzas =
      Cache.get_all()
      |> elem(1)
      |> Enum.filter(fn p -> String.contains?(p.name, search) end)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(pizzas))
  end
end
