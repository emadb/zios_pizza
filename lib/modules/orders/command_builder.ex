defmodule ZiosPizza.Orders.CommandBuilder do
  alias ZiosPizza.Carts.Gateway, as: CartGateway

  @create_order_schema %{
    "type" => "object",
    "properties" => %{
      "payment_token" => %{"type" => "string"}
    },
    "required" => ["payment_token"]
  }

  def build_create_order_cmd(user_id, payload) do
    with :ok <- ExJsonSchema.Validator.validate(@create_order_schema, payload),
         {:ok, cart} <- CartGateway.execute(user_id, :get_state) do
      {:ok, {:create_order, create_order_struct(user_id, payload, cart)}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  defp create_order_struct(user_id, payload, cart) do
    %{user_id: user_id, payment_token: payload["payment_token"], cart: cart}
  end
end
