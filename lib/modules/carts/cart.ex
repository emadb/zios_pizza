defmodule ZiosPizza.Carts.Cart do
  alias ZiosPizza.Carts.CartItem
  defstruct [:user_id, :pizzas, :total, :reserved_slot]

  def initial_state(user_id) do
    %__MODULE__{user_id: user_id, pizzas: [], total: 0}
  end

  def add_pizza(state, item) do
    pizzas =
      case Enum.find(state.pizzas, fn p -> p.pizza_id == item.pizza_id end) do
        nil ->
          state.pizzas ++ [CartItem.build(item)]

        _ ->
          Enum.reduce(state.pizzas, [], fn cp, acc ->
            acc ++ get_pizza(cp, item)
          end)
      end

    %{state | total: get_total(pizzas), pizzas: pizzas}
  end

  defp get_pizza(cp, item) when cp.pizza_id == item.pizza_id do
    [CartItem.build(%{cp | qty: cp.qty + item.qty})]
  end

  defp get_pizza(cp, _) do
    [cp]
  end

  def set_slot(state, payload) do
    %__MODULE__{
      state
      | reserved_slot: payload.datetime
    }
  end

  def release_slot(state) do
    %__MODULE__{
      state
      | reserved_slot: nil
    }
  end

  defp get_total(pizzas) do
    Enum.reduce(pizzas, 0, fn x, acc -> acc + x.total_price end)
  end
end
