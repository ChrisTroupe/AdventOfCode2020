defmodule Day15 do

  def part1() do
    load_data()
    |> speak_until_ind
  end

  def part2() do
    load_data()
    |> speak_until_ind(30000000)
  end

  defp load_data() do
    File.read!("inputs/day15.txt")
    |> String.split(",", trim: true)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  # Part 1
  defp speak_until_ind(starting_nums, stop_turn \\ 2020) do
    starting_turn = length(starting_nums) + 1
    last_num = List.last starting_nums

    {_, cache} = Enum.reduce(starting_nums, {1,%{}}, fn element, {ind, cache} ->
      cache = Map.put(cache, element, ind)
      {ind + 1, cache}
    end)

    cache = Map.delete cache, last_num

    speak last_num, starting_turn, stop_turn, cache
  end

  defp speak(last_num, turn, stop_turn, turn_cache) do
    val = if Map.has_key?(turn_cache, last_num) do
      turn - 1 - turn_cache[last_num]
    else
      0
    end

    turn_cache = Map.put(turn_cache, last_num, turn-1)

    if turn == stop_turn do
      val
    else
      speak(val, turn+1, stop_turn, turn_cache)
    end
  end

end
