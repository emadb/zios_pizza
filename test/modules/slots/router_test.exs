defmodule ZiosPizza.Slots.RouterTest do
  use ZiosPizza.RepoCase
  use ExUnit.Case
  use Plug.Test
  import Mock
  alias ZiosPizza.Slots.Repo
  alias ZiosPizza.Slots.Server

  describe "Slot router" do
    test "GET /slots/:date" do
      conn =
        conn(:get, "/slots/2020-04-09")
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer USER_11")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert Enum.count(res) == 3

      assert Enum.at(res, 0) == %{
               "datetime" => "2020-04-09T01:00:00Z",
               "status" => "available"
             }

      assert Enum.at(res, 1) == %{
               "datetime" => "2020-04-09T02:00:00Z",
               "status" => "available"
             }

      assert Enum.at(res, 2) == %{
               "datetime" => "2020-04-09T04:00:00Z",
               "status" => "available"
             }
    end

    test "GET /slots?from=2020-04-01&to=2020-04-10" do
      conn =
        conn(:get, "/slots?from=2020-04-01&to=2020-04-10")
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer USER_11")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert Enum.count(res) == 4
    end

    test "POST /slots/:date reserve slot" do
      tomorrow = DateTime.utc_now() |> DateTime.add(60 * 60 * 48) |> DateTime.truncate(:second)

      slot = %ZiosPizza.Slots.Slot{
        datetime: tomorrow,
        capacity: 5,
        reserved: 0
      }

      with_mock(Repo, upsert: fn s -> {:ok, s} end, get: fn _ -> {:ok, slot} end) do
        conn(:post, "/slots/#{tomorrow}")
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer USER_6")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

        {:ok, slot} = Server.execute(tomorrow, :get_slot)

        assert %ZiosPizza.Slots.Slot{
                 datetime: ^tomorrow,
                 capacity: 5,
                 reserved: 1
               } = slot

        Process.sleep(200)
      end
    end

    test "POST /slots/:date reserve slot: slot does not exist, should return 400" do
      three_days_from_now =
        DateTime.utc_now() |> DateTime.add(60 * 60 * 24 * 3) |> DateTime.truncate(:second)

      with_mock(Repo, upsert: fn s -> {:ok, s} end, get: fn _ -> :not_found end) do
        conn =
          conn(:post, "/slots/#{three_days_from_now}")
          |> put_req_header("content-type", "application/json")
          |> put_req_header("authorization", "Bearer USER_7")
          |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

        assert conn.status == 400
      end
    end

    test "POST /slots/:date reserve slot: slot is in the past, should return 400" do
      yesterday = DateTime.utc_now() |> DateTime.add(-60 * 60 * 24) |> DateTime.truncate(:second)

      slot = %ZiosPizza.Slots.Slot{
        datetime: yesterday,
        capacity: 5,
        reserved: 0
      }

      with_mock(Repo, upsert: fn s -> {:ok, s} end, get: fn _ -> {:ok, slot} end) do
        conn =
          conn(:post, "/slots/#{yesterday}")
          |> put_req_header("content-type", "application/json")
          |> put_req_header("authorization", "Bearer USER_8")
          |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

        assert conn.status == 400
      end
    end

    test "POST /slots/:date reserve slot: slot is full, should return 400" do
      tomorrow = DateTime.utc_now() |> DateTime.add(60 * 60 * 25) |> DateTime.truncate(:second)

      slot = %ZiosPizza.Slots.Slot{
        datetime: tomorrow,
        capacity: 5,
        reserved: 5
      }

      with_mock(Repo, upsert: fn s -> {:ok, s} end, get: fn _ -> {:ok, slot} end) do
        conn =
          conn(:post, "/slots/#{tomorrow}")
          |> put_req_header("content-type", "application/json")
          |> put_req_header("authorization", "Bearer USER_9")
          |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

        assert conn.status == 400
      end
    end
  end
end
