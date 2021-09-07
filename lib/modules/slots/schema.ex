defmodule ZiosPizza.Slots.Schema do
  use Ecto.Schema

  @primary_key {:datetime, :utc_datetime, autogenerate: false}

  schema "slots" do
    field(:capacity, :integer)
    field(:reserved, :integer)
    timestamps()
  end
end
