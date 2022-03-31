# alias ZiosPizza.Repo
# alias ZiosPizza.Slots.Schema, as: Slot

# today = Date.utc_today() |> Date.to_string()
# {:ok, d1, _} = DateTime.from_iso8601(today <> "T20:00:00Z")
# {:ok, d2, _} = DateTime.from_iso8601(today <> "T21:00:00Z")
# {:ok, d3, _} = DateTime.from_iso8601(today <> "T22:00:00Z")
# {:ok, d4, _} = DateTime.from_iso8601(today <> "T23:00:00Z")

# Repo.insert!(%Slot{datetime: d1, capacity: 5, reserved: 0})
# Repo.insert!(%Slot{datetime: d2, capacity: 5, reserved: 0})
# Repo.insert!(%Slot{datetime: d3, capacity: 5, reserved: 0})
# Repo.insert!(%Slot{datetime: d4, capacity: 5, reserved: 0})
