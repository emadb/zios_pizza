defmodule ZiosPizza.RepoCase do
  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias ZiosPizza.Repo

      import Ecto
      import Ecto.Query
      import ZiosPizza.RepoCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(ZiosPizza.Repo)

    unless tags[:async] do
      Sandbox.mode(ZiosPizza.Repo, {:shared, self()})
    end

    :ok
  end
end
