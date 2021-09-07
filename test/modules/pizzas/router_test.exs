defmodule ZiosPizza.Pizzas.RouterTest do
  use ExUnit.Case
  use Plug.Test
  use ZiosPizza.RepoCase

  describe "Pizzas router" do
    test "GET /pizzas?search=mar should a list of matching pizzas" do
      conn =
        conn(:get, "/pizzas?search=mar")
        |> put_req_header("content-type", "application/json")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert Enum.all?(res, fn p ->
               starts_with_ignoring_case?(p["name"], "mar")
             end) == true
    end

    test "GET /pizzas?search=THIS_PIZZA_DOES_NOT_EXISTS should an empty list" do
      conn =
        conn(:get, "/pizzas?search=THIS_PIZZA_DOES_NOT_EXISTS")
        |> put_req_header("content-type", "application/json")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert res == []
    end

    test "GET /pizzas/:id should return a single product" do
      conn =
        conn(:get, "/pizzas/2")
        |> put_req_header("content-type", "application/json")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert res["id"] == 2
    end

    test "GET /pizzas/THIS_IS_NOT_AN_ID should return 400" do
      conn =
        conn(:get, "/pizzas/THIS_IS_NOT_AN_ID")
        |> put_req_header("content-type", "application/json")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      assert conn.status == 400
    end

    test "GET /pizzas/9999 should return 400" do
      conn =
        conn(:get, "/pizzas/9999")
        |> put_req_header("content-type", "application/json")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      assert conn.status == 404
    end
  end

  defp starts_with_ignoring_case?(string, match) do
    string
    |> String.downcase()
    |> String.starts_with?(match)
  end
end
