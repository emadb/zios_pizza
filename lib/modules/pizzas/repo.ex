defmodule ZiosPizza.Pizzas.Repo do
  alias ZiosPizza.Pizzas.Schema

  def get_all do
    ZiosPizza.Repo.all(Schema)
    |> Enum.map(&serialize_to_map/1)
  end

  defp serialize_to_map(struct) do
    map =
      struct
      |> Map.delete(:__meta__)
      |> Map.from_struct()

    Enum.reduce(Map.keys(map), map, fn m, acc ->
      with true <- is_map(acc[m]),
           true <- Map.has_key?(acc[m], :__meta__) do
        Map.put(acc, m, serialize_to_map(acc[m]))
      else
        _ -> acc
      end
    end)
  end
end
