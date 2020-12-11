defmodule Day10 do

  def part1() do
    {_, diff_map} =load_data()
    |> adapters_to_diff_map

    one_jolt_ct = Map.get(diff_map, 1, 0)
    three_jolt_ct = Map.get(diff_map, 3, 0) + 1

    one_jolt_ct * three_jolt_ct
  end

  def part2() do
    load_data()
    |> get_combo_count
  end

  defp load_data() do
    File.stream!("inputs/day10.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list
  end

  # Part 1
  defp adapters_to_diff_map(adapters) do
    adapters
    |> Enum.sort
    |> Enum.reduce({0, %{}}, &atdm_reduce_fn/2)
  end
  defp atdm_reduce_fn(element, {prev_elem, diff_map}) do
    diff_map = Map.update(diff_map, element-prev_elem, 1, &(&1+1))
    {element, diff_map}
  end

  # Part 2
  # Set of processing numbers, list of numbers to be processed
  # Above window, below window
  # combo map

  # Starting from the end, sum the mapped combos of the for the values in your "above window"
  # Add the available adapters in your "below window" to the process list in order of greatest to least

  # Need to set combo for highest elem to 1

  defp get_combo_count(adapters) do
    adapters = adapters
    |> Enum.sort
    |> Enum.reverse

    combo_map = get_final_combos adapters, %{}

    combo_map[0]
  end

  defp get_final_combos([], combo_map) do
    combos = sum_upper_combos(0, combo_map)
    Map.put(combo_map, 0, combos)
  end
  defp get_final_combos([head | tail], combo_map) do
    combos = sum_upper_combos(head, combo_map)

    combo_map = Map.put(combo_map, head, combos)

    get_final_combos(tail, combo_map)
  end


  defp sum_upper_combos(adapter, combo_map, limit \\ 3, acc \\ 0)
  defp sum_upper_combos(_adapter, _combo_map, 0, 0), do: 1
  defp sum_upper_combos(_adapter, _combo_map, 0, acc), do: acc
  defp sum_upper_combos(adapter, combo_map, limit, acc) do
    acc = acc + Map.get(combo_map, adapter+limit, 0)
    sum_upper_combos(adapter, combo_map, limit - 1, acc)
  end

end
