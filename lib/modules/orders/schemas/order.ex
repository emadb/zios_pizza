defmodule ZiosPizza.Orders.Schemas.Order do
  use Ecto.Schema

  @primary_key {:code, :string, autogenerate: false}

  schema "orders" do
    field(:user_id, :string)
    field(:date, :utc_datetime)
    field(:state, Ecto.Atom)
    field(:transaction_info, :map)
    field(:reserved_slot, :utc_datetime)
    field(:total_price, :integer)
    embeds_many(:pizzas, ZiosPizza.Orders.Schemas.OrderItem)
    timestamps()
  end
end

defmodule ZiosPizza.Orders.Schemas.OrderItem do
  use Ecto.Schema

  @primary_key {:pizza_id, :integer, autogenerate: false}

  embedded_schema do
    field(:qty, :integer)
    field(:name, :string)
    field(:price, :integer)
  end
end
