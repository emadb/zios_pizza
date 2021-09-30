use Mix.Config

config :zios_pizza,
  available_pizzaioli: 2,
  prepare_time: 1000..2000

config :zios_pizza, ZiosPizza.Repo,
  database: "zios_pizza_test",
  username: "postgres",
  password: "postgres",
  hostname: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :info
