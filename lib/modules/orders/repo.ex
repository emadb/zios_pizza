defmodule ZiosPizza.Orders.Repo do
  alias ZiosPizza.Orders.Schemas.Order
  alias ZiosPizza.Utils.Functions

  def get_by_code(code) do
    case ZiosPizza.Repo.get_by(Order, code: code) do
      nil ->
        :not_found

      o ->
        {:ok,
         %ZiosPizza.Orders.Order{
           user_id: o.user_id,
           code: o.code,
           state: o.state,
           date: o.date,
           reserved_slot: o.reserved_slot,
           total_price: o.total_price,
           pizzas: o.pizzas |> Enum.map(&Functions.atomize_keys/1)
         }}
    end
  end

  def get_by_code_and_user(code, user_id) do
    case ZiosPizza.Repo.get_by(Order, code: code, user_id: user_id) do
      nil ->
        :not_found

      o ->
        {:ok,
         %ZiosPizza.Orders.Order{
           user_id: o.user_id,
           date: o.date,
           code: o.code,
           state: o.state,
           reserved_slot: o.reserved_slot,
           total_price: o.total_price,
           pizzas: o.pizzas |> Enum.map(&Functions.atomize_keys/1)
         }}
    end
  end

  def upsert(o) do
    order = %Order{
      user_id: o.user_id,
      date: DateTime.truncate(o.date, :second),
      state: o.state,
      code: o.code,
      reserved_slot: DateTime.truncate(o.reserved_slot, :second),
      total_price: o.total_price,
      pizzas: Enum.map(o.pizzas, &from_cart_item/1)
    }

    {:ok, res} = ZiosPizza.Repo.insert(order, on_conflict: :replace_all, conflict_target: :code)
    res
  end

  defp from_cart_item(s) do
    %{
      qty: s.qty,
      name: s.name,
      price: s.price
    }
  end
end
