import Config

config :zios_pizza,
  available_pizzaioli: 10,
  prepare_time: 10_000..20_000

config :zios_pizza,
  ecto_repos: [ZiosPizza.Repo],
  process_timeout: 10000

config :zios_pizza,
       ZiosPizza.Repo,
       migration_timestamps: [type: :utc_datetime]

import_config "#{Mix.env()}.exs"
