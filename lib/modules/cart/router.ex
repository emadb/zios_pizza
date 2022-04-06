defmodule ZiosPizza.Cart.Router do
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(ZiosPizza.Plug.Auth)

  plug(:match)
  plug(:dispatch)

  post "/" do
    user_id = conn.assign[:user]

    case CommandBuilder.build_add_pizza_cmd(conn.body_params) do
      {:ok, cmd} ->
        {:ok, cart} = ZiosPizza.Cart.Gateway.execute(user_id, cmd)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(201, Jason.encode!(cart))

      {:error, errors} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(errors))
    end
  end
end
