# alias ZiosPizza.Repo
# alias ZiosPizza.Pizzas.Schema, as: Pizza
# alias ZiosPizza.Slots.Schema, as: Slot

# Repo.insert!(%Pizza{id: 1, name: "Margherita", price: 500})
# Repo.insert!(%Pizza{id: 2, name: "Marinara", price: 450})
# Repo.insert!(%Pizza{id: 3, name: "Verdure", price: 700})
# Repo.insert!(%Pizza{id: 4, name: "Prosciutto e funghi", price: 650})
# Repo.insert!(%Pizza{id: 5, name: "Bufala", price: 750})

# Repo.insert!(%Slot{
#   datetime: ~U[2020-04-09 01:00:00.000000Z] |> DateTime.truncate(:second),
#   capacity: 2,
#   reserved: 0
# })

# Repo.insert!(%Slot{
#   datetime: ~U[2020-04-09 02:00:00.000000Z] |> DateTime.truncate(:second),
#   capacity: 2,
#   reserved: 0
# })

# Repo.insert!(%Slot{
#   datetime: ~U[2020-04-09 04:00:00.000000Z] |> DateTime.truncate(:second),
#   capacity: 3,
#   reserved: 0
# })

# Repo.insert!(%Slot{
#   datetime: ~U[2020-04-11 01:00:00.000000Z] |> DateTime.truncate(:second),
#   capacity: 2,
#   reserved: 0
# })

# Repo.insert!(%Slot{
#   datetime: ~U[2020-04-01 02:00:00.000000Z] |> DateTime.truncate(:second),
#   capacity: 2,
#   reserved: 0
# })
