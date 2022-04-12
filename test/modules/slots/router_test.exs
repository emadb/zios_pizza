defmodule ZiosPizza.Slots.RouterTest do
  use ExUnit.Case
  use Plug.Test
  use ZiosPizza.RepoCase

  describe "Slots router" do
    test "GET /slots/2022-04-12 should return the slots of 12th April 2022" do
      conn =
        conn(:get, "/slots/2022-04-12")
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer USER_1")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert Enum.count(res) > 0

      # [%{
      #  "datetime" => "2022-04-12T20:00:00.000Z",
      #  "status" => "available"
      # },
      # %{
      #  "datetime" => "2022-04-12T21:00:00.000Z",
      #  "status" => "not available"
      # }]
      #

    end

    test "POST /slots/2022-04-12T20:00:00.000Z should reserve the slot" do
      conn =
        conn(:get, "/slots/2022-04-12T20:00:00.000Z")
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer USER_1")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      # res = Jason.decode!(conn.resp_body)

      assert conn.status == 201
    end
  end

  defp starts_with_ignoring_case?(string, match) do
    string
    |> String.downcase()
    |> String.starts_with?(match)
  end
end
