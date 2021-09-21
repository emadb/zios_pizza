defmodule ZiosPizza.Pizza.Repo do

  def get_all do
    ZiosPizza.Repo.all(ZiosPizza.Pizza.Schema)
  end

end
