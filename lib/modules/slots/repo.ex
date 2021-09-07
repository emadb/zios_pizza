defmodule ZiosPizza.Slots.Repo do
  alias ZiosPizza.Slots.Schema
  import Ecto.Query

  def get(datetime) do
    case ZiosPizza.Repo.get(Schema, datetime) do
      nil ->
        :not_found

      slot ->
        {:ok,
         %ZiosPizza.Slots.Slot{
           datetime: slot.datetime,
           capacity: slot.capacity,
           reserved: slot.reserved
         }}
    end
  end

  def get_by_date_range(from, to) do
    from = Date.to_iso8601(from) <> "T00:00:00Z"
    to = Date.to_iso8601(to) <> "T23:59:59Z"

    from(s in Schema)
    |> where([s], s.datetime >= ^from and s.datetime <= ^to)
    |> ZiosPizza.Repo.all()
  end

  def get_by_date(date) do
    get_by_date_range(date, date)
  end

  def upsert(s) do
    slot = %Schema{
      datetime: DateTime.truncate(s.datetime, :second),
      capacity: s.capacity,
      reserved: s.reserved
    }

    {:ok, p} = ZiosPizza.Repo.insert(slot, on_conflict: :replace_all, conflict_target: :datetime)
    p
  end
end
