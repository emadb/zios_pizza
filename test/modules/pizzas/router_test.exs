defmodule ZiosPizza.Modules.PizzasTest do
  use ExUnit.Case
  use Plug.Test
  use ZiosPizza.RepoCase

  describe "Pizzas router" do
    test "GET /pizzas should the list" do
      conn =
        conn(:get, "/pizzas")
        |> put_req_header("content-type", "application/json")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      assert conn.status == 200
      res = Jason.decode!(conn.resp_body)

      assert Enum.count(res) == 5
    end
  end
end
