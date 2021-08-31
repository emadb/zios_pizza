alias ZiosPizza.Repo
alias ZiosPizza.Pizzas.Schema, as: Pizza

Repo.insert!(%Pizza{name: "Margherita", price: 500})
Repo.insert!(%Pizza{name: "Verdure", price: 700})
Repo.insert!(%Pizza{name: "Prosciutto e funghi", price: 650})
Repo.insert!(%Pizza{name: "Bufala", price: 750})
