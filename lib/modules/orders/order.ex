defmodule ZiosPizza.Orders.Order do
  defstruct [
    :user_id,
    :code,
    :state,
    :reserved_slot,
    :total_price,
    :pizzas,
    :date
  ]

  def initial_state(code) do
    %__MODULE__{code: code, state: :init}
  end

  def create(state, cart) do
    total = Enum.reduce(cart.pizzas, 0, fn ci, acc -> acc + ci.total_price end)

    %__MODULE__{
      state
      | user_id: cart.user_id,
        state: :received,
        date: DateTime.utc_now(),
        reserved_slot: cart.reserved_slot,
        pizzas: cart.pizzas,
        total_price: total
    }
  end

  def valid?(order) do
    with false <- is_nil(order.date),
         false <- is_nil(order.reserved_slot),
         false <- is_nil(order.pizzas),
         false <- Enum.empty?(order.pizzas) do
      true
    else
      _ -> false
    end
  end

  def set_ready(order) do
    %__MODULE__{order | state: :ready}
  end

  def generate_new_code do
    Ecto.UUID.generate()
  end
end
