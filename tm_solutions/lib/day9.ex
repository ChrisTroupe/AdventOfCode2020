defmodule Day9 do

  def part1() do
    load_data()
    |> Enum.reduce_while({0, []}, &reduce_fn/2)
  end

  def part2() do
    goal_num = part1()
    if is_integer(goal_num) do
      {num1, num2} = load_data()
      |> Enum.reduce_while({[], goal_num}, &contiguous_sum/2)

      num1 + num2
    end
  end

  def load_data() do
    File.stream!("inputs/day9.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end

  # Part 1
  defp reduce_fn(element, {curr_ind, prev_list}) do
    if curr_ind > 25 and !list_contain_numbers?(prev_list, element) do
      {:halt, element}
    else
      {:cont, {curr_ind+1, add_to_list(prev_list, element)}}
    end
  end

  defp list_contain_numbers?(list, goal) do
    {num1, num2} = Day1.get_matching_nums(list, goal)

    num1 && num2
  end

  defp add_to_list(list, num) do
    case length list do
      x when x >= 25 ->
        list = List.delete_at(list, -1)
        [num | list]
      _ -> [num | list]
    end
  end

  # part 2
  defp contiguous_sum(element, {window_list, goal}) do
    window_list = [element | window_list]
    window_sum = Enum.sum window_list

    {window_list, window_sum} = if window_sum > goal, do: remove_from_window(window_list, goal), else: {window_list, window_sum}

    cond do
      window_sum < goal -> {:cont, {window_list, goal}}
      window_sum == goal -> {:halt, Enum.min_max(window_list)}
    end
  end

  defp remove_from_window(window_list, goal) do
    window_list = List.delete_at(window_list, -1)
    window_sum = Enum.sum window_list

    if window_sum > goal do
      remove_from_window(window_list, goal)
    else
      {window_list, window_sum}
    end
  end

end
