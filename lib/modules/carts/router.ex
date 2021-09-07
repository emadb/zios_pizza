defmodule ZiosPizza.Carts.Router do
  use Plug.Router
  alias ZiosPizza.Carts.CommandBuilder
  alias ZiosPizza.Carts.Gateway

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(ZiosPizza.Plug.Auth)
  plug(:match)
  plug(:dispatch)

  post "/" do
    user = conn.assigns[:user]

    case CommandBuilder.build_add_pizza_cmd(conn.body_params) do
      {:ok, cmd} ->
        {:ok, cart} = Gateway.execute(user, cmd)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(201, Jason.encode!(project_cart(cart)))

      {:error, errors} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(errors))
    end
  end

  get "/" do
    user = conn.assigns[:user]

    {:ok, cart} = Gateway.execute(user, :get_state)
    send_resp(conn, 200, Jason.encode!(project_cart(cart)))
  end

  match(_, do: send_resp(conn, 404, "Not found"))

  defp project_cart(cart) do
    %{
      total: cart.total,
      reserved_slot: cart.reserved_slot,
      pizzas:
        Enum.map(cart.pizzas, fn p ->
          %{
            pizza_id: p.pizza_id,
            name: p.name,
            price: p.price,
            qty: p.qty,
            total_price: p.total_price
          }
        end)
    }
  end
end
