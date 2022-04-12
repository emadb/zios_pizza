defmodule ZiosPizza.Repo.Migrations.CreateSlotsTable do
  use Ecto.Migration

  def change do
    create table("slots", primary_key: false) do
      add :datetime, :utc_datetime, primary_key: true
      add :capacity, :integer
      add :reserved, :integer
      timestamps()
    end
  end
end
