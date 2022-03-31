defmodule ZiosPizza.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/ping" do
    version = Application.spec(:zios_pizza, :vsn) |> to_string()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{version: version}))
  end

  forward("/pizzas", to: ZiosPizza.Pizzas.Router)

  match(_, do: send_resp(conn, 404, "Not found"))
end
