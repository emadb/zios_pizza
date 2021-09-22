defmodule ZiosPizza.Pizza.Repo do
  def get_all do
    ZiosPizza.Repo.all(ZiosPizza.Pizza.Schema)
  end

  def search_by(nil), do: get_all()
  def search_by(""), do: get_all()
  def search_by(term) do
    filter = fn p ->
      p.name
      |>String.downcase
      |>String.contains?(term)
    end

    get_all() |>Enum.filter(filter)
  end
end
