defmodule ZiosPizza.Repo do
  use Ecto.Repo,
    otp_app: :zios_pizza,
    adapter: Ecto.Adapters.Postgres
end
