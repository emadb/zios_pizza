defmodule ZiosPizza.Pizza.Schema do
  use Ecto.Schema

  schema "pizzas" do
    field :name, :string
    field :price, :integer
    timestamps()
  end

end
