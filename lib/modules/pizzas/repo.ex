defmodule ZiosPizza.Pizzas.Repo do

  def get_all do
    ZiosPizza.Repo.all(ZiosPizza.Pizzas.Schema)
  end

end
