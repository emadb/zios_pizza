defmodule ZiosPizza.Cart.CommandBuilder do
  alias ExJsonSchema.Validator

  def build_add_pizza_cmd(payload) do
    payload_schema = %{
      "type" => "object",
      "properties" => %{
        "pizza_id" => %{"type" => "integer"}
      }
    }

    case Validator.validate(payload_schema, payload) do
      :ok ->
        # TODO: verificare che pizza_id esista
        {:ok, {:add_pizza, %{pizza_id: payload["pizza_id"]}}}

      {:error, errors} ->
        {:error, errors}
    end
  end
end
