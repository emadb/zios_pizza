defmodule ZiosPizza.Repo.Migrations.CreatePizzas do
  use Ecto.Migration

  def change do
    create table(:pizzas) do
      add :name, :string
      add :price, :integer
      timestamps()
    end
  end
end
