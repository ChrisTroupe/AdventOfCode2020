defmodule Day3 do
  def part1() do
    geology = load_data()

    geology = List.delete_at(geology, 0)

    num_trees(geology, 3, 0)
  end

  def part2() do
    geology = load_data()
    geology = List.delete_at(geology, 0)

    ans1 = num_trees(geology, 1, 1, 1, 0)
    ans2 = num_trees(geology, 3, 3, 1, 0)
    ans3 = num_trees(geology, 5, 5, 1, 0)
    ans4 = num_trees(geology, 7, 7, 1, 0)
    ans5 = num_trees(Enum.drop(geology, 1), 1, 1, 2, 0)

    ans1 * ans2 * ans3 * ans4 * ans5
  end

  # Data loading
  def load_data() do
    file_data = File.read!("inputs/day3.txt")

    file_data
    |> String.split("\n")
    |> Enum.map(&line_to_list/1)
  end

  defp line_to_list(line) do
    String.to_charlist(line)
      |> Enum.map(fn
        ?. -> false
        ?# -> true
      end)
  end

  # Part 1 Logic
  defp num_trees([], _xpos, tree_ct), do: tree_ct
  defp num_trees([head | tail], xpos, tree_ct) do
    if Enum.at head, rem(xpos, length head) do
      num_trees(tail, xpos+3, tree_ct + 1)
    else
      num_trees(tail, xpos+3, tree_ct)
    end
  end

  # Part 2 Logic
  defp num_trees([], _xpos, _dx, _dy, tree_ct), do: tree_ct
  defp num_trees([head | tail], xpos, dx, dy, tree_ct) do
    tail = Enum.drop(tail, dy-1)
    if Enum.at head, rem(xpos, length head) do
      num_trees(tail, xpos+dx, dx, dy, tree_ct + 1)
    else
      num_trees(tail, xpos+dx, dx, dy, tree_ct)
    end
  end
end
