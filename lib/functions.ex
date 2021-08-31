defmodule ZiosPizza.Utils.Functions do
  def serialize_to_map(struct) do
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

  def atomize_keys(nil), do: nil

  def atomize_keys(%{__struct__: _} = struct) do
    struct
  end

  def atomize_keys(%{} = map) do
    map
    |> Enum.map(fn {k, v} -> {String.to_atom(k), atomize_keys(v)} end)
    |> Enum.into(%{})
  end

  def atomize_keys([head | rest]) do
    [atomize_keys(head) | atomize_keys(rest)]
  end

  def atomize_keys(not_a_map) do
    not_a_map
  end

  def subtract_minutes(datetime, minutes) do
    DateTime.add(datetime, -60 * minutes, :second)
  end
end
