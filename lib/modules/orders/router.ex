defmodule ZiosPizza.Orders.Router do
  use Plug.Router
  alias ZiosPizza.Orders.CommandBuilder
  alias ZiosPizza.Orders.Gateway
  alias ZiosPizza.Orders.Order
  alias ZiosPizza.Orders.Repo

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(ZiosPizza.Plug.Auth)
  plug(:match)
  plug(:dispatch)

  get "/:code" do
    user = conn.assigns[:user]

    case Repo.get_by_code_and_user(code, user) do
      {:ok, order} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(build_web_order(order)))

      :not_found ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "Ordine non esistente"}))
    end
  end

  post "/" do
    user = conn.assigns[:user]
    code = Order.generate_new_code()

    with {:ok, cmd} <- CommandBuilder.build_create_order_cmd(user, conn.body_params),
         {:ok, order} <- Gateway.execute(code, cmd) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(201, Jason.encode!(build_web_order(order)))
    else
      {:error, _} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: "Payload non valido"}))

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(500, Jason.encode!(%{error: "Errore durante la creazione dell'ordine"}))
    end
  end

  defp build_web_order(order) do
    %{
      code: order.code,
      reserved_slot: order.reserved_slot,
      total_price: order.total_price
    }
  end
end
