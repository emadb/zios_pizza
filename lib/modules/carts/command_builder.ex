defmodule ZiosPizza.Carts.CommandBuilder do
  alias ZiosPizza.Pizzas.Cache

  @add_to_cart_schema %{
    "type" => "object",
    "properties" => %{
      "pizza_id" => %{"type" => "number"},
      "qty" => %{"type" => "number"}
    },
    "required" => ["pizza_id"]
  }

  def build_add_pizza_cmd(payload) do
    case ExJsonSchema.Validator.validate(@add_to_cart_schema, payload) do
      :ok ->
        {:ok,
         {:add_pizza, build_add_pizza_payload(payload["pizza_id"], Map.get(payload, "qty", 1))}}

      {:error, errors} ->
        {:error, Enum.map(errors, &elem(&1, 0))}
    end
  end

  defp build_add_pizza_payload(pizza_id, qty) do
    pizza = get_pizza_info(pizza_id)
    %{pizza_id: pizza.id, name: pizza.name, price: pizza.price, qty: qty}
  end

  defp get_pizza_info(pizza_id) do
    {id, _} = Integer.parse(to_string(pizza_id))
    {:ok, pizza} = Cache.get(id)
    pizza
  end
end
