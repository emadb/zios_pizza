defmodule ZiosPizza.RouterTest do
  use ExUnit.Case
  use Plug.Test

  describe "Main router" do
    test "GET /ping should return pong" do
      conn =
        conn(:get, "/ping")
        |> put_req_header("content-type", "application/json")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert %{"version" => _} = res
    end
  end
end
