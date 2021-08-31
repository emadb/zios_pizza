defmodule ZiosPizza.DelayAsserts do
  def wait_until(p) do
    start_time = System.os_time(:millisecond)
    do_wait_until(p, start_time)
  end

  defp do_wait_until(p, start_time) do
    if System.os_time(:millisecond) - start_time > 5000 do
      raise "wait_until timeout"
    else
      execute(p) || do_wait_until(p, start_time)
    end
  end

  defp execute(p) do
    p.()
  rescue
    _ -> false
  end
end
