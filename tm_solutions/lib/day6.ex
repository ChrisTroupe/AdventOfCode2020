defmodule Day6 do

  def part1() do
    load_data()
    |> get_num_unique
  end

  def part2() do
    load_data()
    |> get_total_common
  end

  defp load_data() do
    File.stream!("inputs/day6.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_while([], &chunk_fn/2, &after_fn/1)
  end

  defp chunk_fn("", acc), do: {:cont, Enum.reverse(acc), []}
  defp chunk_fn(element, acc), do: {:cont, [element | acc]}

  defp after_fn([]), do: {:cont, []}
  defp after_fn(acc), do: {:cont, acc, []}

  # Part 1
  defp get_num_unique(data_stream) do
    data_stream
    |> Stream.map(&(Enum.reduce(&1, fn x, acc -> x <> acc end))) # Could have used Enum.join/1
    |> Stream.map(&String.to_charlist/1)
    |> Stream.map(&Enum.uniq/1)
    |> Stream.map(&Kernel.length/1)
    |> Enum.reduce(&(&1+&2))
  end

  # Part 2
  defp get_total_common(data_stream) do
    data_stream
    |> Stream.map(&common_answers/1)
    |> Stream.map(&MapSet.size/1)
    |> Enum.reduce(&(&1+&2))
  end

  defp common_answers(answers_list) do
    answers_list
    |> Stream.map(&String.to_charlist/1)
    |> Stream.map(&(MapSet.new(&1)))
    |> Enum.reduce(&(MapSet.intersection(&1, &2)))
  end

end
