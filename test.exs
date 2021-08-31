
defmodule Foo do
  def set_busy([name | pizzaioli], current, list) when current == name do
    [String.upcase(name) | pizzaioli ++ list]
  end

  def set_busy([name | pizzaioli], current, list) do
    set_busy(pizzaioli, current, list ++ [name])
  end
end


IO.inspect ["uno", "due", "tre", "quattro"]
    |> Foo.set_busy("quattro", [])
    |> Foo.set_busy("due", [])
    |>Foo.set_busy("uno", [])
