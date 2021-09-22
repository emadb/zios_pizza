defmodule ZiosPizza.Pizza.RouterTest do
  use ExUnit.Case
  use Plug.Test
  use ZiosPizza.RepoCase

  test "GET /pizzas should return the list of all pizzas" do
    conn =
      conn(:get, "/pizzas")
      |> put_req_header("content-type", "application/json")
      |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

    assert conn.status == 200
    res = Jason.decode!(conn.resp_body)

    assert Enum.count(res) > 0
  end

  test "GET /pizzas?search=mar" do
    conn =
      conn(:get, "/pizzas?search=mar")
      |> put_req_header("content-type", "application/json")
      |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

    assert conn.status == 200
    res = Jason.decode!(conn.resp_body)

    assert Enum.count(res) == 2
    assert Enum.all?(res, fn p ->
      p["name"]
      |> String.downcase()
      |> String.starts_with?("mar")
    end)
  end
end
