defmodule Day13 do

  def part1() do
    load_data()
    |> get_next_bus
    |> (fn {bus, wait_time} -> bus * wait_time end).()
  end

  def part2() do
    load_second_line()
    |> chinese_rem
  end

  defp load_data() do
    File.stream!("inputs/day13.txt")
    |> Enum.map(&String.trim/1)
    |> process_input
  end

  defp process_input([timestamp, buses]) do
    buses = buses
    |> String.split(",", trim: true)
    |> Stream.filter(&(&1 != "x"))
    |> Enum.map(&String.to_integer/1)

    [String.to_integer(timestamp), buses]
  end

  defp load_second_line() do
    File.stream!("inputs/day13.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.at(1)
    |> String.split(",", trim: true)
    |> Enum.map_reduce(0, fn element, ind ->
      if element != "x" do
        {{ind, String.to_integer(element)}, ind+1}
      else
        {{ind, nil}, ind+1}
      end
    end)
    |> elem(0)
    |> Enum.filter(fn {_ind, val} -> val != nil end)
  end

  # Part 1
  defp get_next_bus([timestamp, buses]) do
    buses
    |> Stream.map(&(next_time(timestamp, &1)))
    |> Enum.min(fn {_, time_before}, {_, min_before} -> time_before <= min_before end)
  end

  defp next_time(timestamp, bus) do
    time_before = rem(timestamp, bus)
    if time_before != 0 do
      {bus, bus - time_before}
    else
      {bus, 0}
    end
  end

  # Part 2
  defp chinese_rem(bus_infos, timestamp \\ 0, step \\ 1)
  defp chinese_rem([], timestamp, _step), do: timestamp
  defp chinese_rem([{ind, bus} | rest], timestamp, step) do
    needed_rem = absrem(bus - ind, bus)

    timestamp = crt_helper(bus, timestamp, needed_rem, step)

    IO.inspect Integer.to_string(timestamp) <> ":" <> Integer.to_string(rem(timestamp, bus))
    chinese_rem(rest, timestamp, step * bus)
  end

  defp crt_helper(bus, timestamp, needed_rem, step) when rem(timestamp, bus) != needed_rem do
    crt_helper(bus, timestamp + step, needed_rem, step)
  end
  defp crt_helper(_bus, timestamp, _needed_rem, _step), do: timestamp

  defp absrem(dividend, divisor) when dividend < 0 do
    absrem(dividend + divisor, divisor)
  end
  defp absrem(dividend, divisor) do
    rem dividend, divisor
  end

end
