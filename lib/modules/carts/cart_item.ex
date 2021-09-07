defmodule ZiosPizza.Carts.CartItem do
  defstruct [
    :pizza_id,
    :name,
    :qty,
    :price,
    :total_price
  ]

  def build(item) do
    %__MODULE__{
      pizza_id: item.pizza_id,
      name: item.name,
      qty: item.qty,
      price: item.price,
      total_price: item.qty * item.price
    }
  end
end
