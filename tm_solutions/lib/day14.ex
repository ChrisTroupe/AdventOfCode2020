defmodule Day14 do

  def part1() do
    load_data()
    |> Enum.reduce({%{}, []}, &reduce_fn/2)
    |> elem(0)
    |> Map.values
    |> Enum.sum
  end

  def part2() do
    load_data(true)
    |> Enum.reduce({%{}, []}, &reduce_fn_2/2)
    |> elem(0)
    |> Map.values
    |> Enum.sum
  end

  defp load_data(part2? \\ false) do
    File.stream!("inputs/day14.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&(parse_instr(&1, part2?)))
  end

  defp parse_instr(line, part2?) do
    if String.starts_with?(line, "mem") do
      matches = Regex.run(~r"^mem\[(\d+)\]\ =\ (\d+)$", line)
      case matches do
        [_, loc, val] ->
          if !part2? do
            {:mem, String.to_integer(loc), num_to_bin_charlist(val)}
          else
            {:mem, num_to_bin_charlist(loc), String.to_integer(val)}
          end
        _ -> {:mem, :nil, :nil}
      end
    else
      {:mask, String.split(line, " ", trim: true) |> List.last |> String.to_charlist}
    end
  end

  defp num_to_bin_charlist(val) when is_binary(val) do
    simple_bin_str = Integer.to_string(String.to_integer(val), 2)
    curr_len = byte_size(simple_bin_str)
    prefix = String.duplicate("0", 36 - curr_len)

    String.to_charlist(prefix <> simple_bin_str)
  end

  # Part 1
  defp reduce_fn({:mask, mask}, {mem_map, _curr_mask}), do: {mem_map, mask}
  defp reduce_fn({:mem, loc, bin_value}, {mem_map, curr_mask}) do
    new_map = perform_mask(curr_mask, bin_value)
    |> Integer.parse(2)
    |> elem(0)
    |> (&(Map.put(mem_map, loc, &1))).()

    {new_map, curr_mask}
  end

  defp perform_mask(mask, num, acc \\ [])
  defp perform_mask([], [], acc), do: Enum.reverse(acc) |> List.to_string
  defp perform_mask([m | mask], [n | num], acc) do
    case m do
      ?X -> perform_mask(mask, num, [n | acc])
      ?1 -> perform_mask(mask, num, [?1 | acc])
      ?0 -> perform_mask(mask, num, [?0 | acc])
    end
  end

  # Part 2
  defp reduce_fn_2({:mask, mask}, {mem_map, _curr_mask}), do: {mem_map, mask}
  defp reduce_fn_2({:mem, loc, value}, {mem_map, curr_mask}) do
    new_map = perform_mask_2(curr_mask, loc)
    |> get_locs
    |> Enum.reduce(mem_map, fn val, map -> Map.put(map, val, value) end)

    {new_map, curr_mask}
  end

  defp perform_mask_2(mask, num, acc \\ [])
  defp perform_mask_2([], [], acc), do: Enum.reverse(acc)
  defp perform_mask_2([m | mask], [n | num], acc) do
    case m do
      ?X -> perform_mask_2(mask, num, [?X | acc])
      ?1 -> perform_mask_2(mask, num, [?1 | acc])
      ?0 -> perform_mask_2(mask, num, [n | acc])
    end
  end

  defp get_locs(val) when is_list(val) do
    Enum.reduce(val, [[]], &get_locs/2)
    |> Stream.map(&Enum.reverse/1)
    |> Stream.map(&List.to_string/1)
    |> Stream.map(&(Integer.parse(&1, 2)))
    |> Enum.map(&(elem(&1, 0)))
  end

  defp get_locs(?X, locs) do
    ones = Enum.map(locs, fn bin_list -> [?1 | bin_list] end)
    zeros = Enum.map(locs, fn bin_list -> [?0 | bin_list] end)

    ones ++ zeros
  end
  defp get_locs(num, locs) do
    Enum.map(locs, fn bin_list -> [num | bin_list] end)
  end

end
