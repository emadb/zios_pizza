defmodule ZiosPizza.Repo.Migrations.CreateOrdersTable do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :code, :string, primary_key: true
      add :date, :utc_datetime
      add :state, :string
      add :user_id, :string
      add :transaction_info, :jsonb
      add :reserved_slot, :utc_datetime
      add :total_price, :integer
      add :pizzas, :jsonb
      timestamps()
    end
    create unique_index(:orders, [:code])
  end
end
