defmodule Day2 do
  # entrypoints
  def part1() do
    data = load_data()

    get_num_valid_pass_count(data, 0)
  end

  def part2() do
    data = load_data()

    get_num_valid_pass_pos(data, 0)
  end

  # Data parsing
  defp load_data() do
    file_data = File.read!("inputs/day2.txt")
    data = file_data
      |> String.split("\n", trim: true)
      |> Enum.map(&split_line/1)

    data
  end

  defp split_line(line) do
    [range, letter, pass] = String.split(line, " ", trim: true)
    [min, max] = String.split(range, "-")
    letter = String.slice(letter, 0..0)
      |> to_charlist
      |> List.first

    {{String.to_integer(min), String.to_integer(max)}, letter, pass}
  end

  # Part 1 logic
  defp get_num_valid_pass_count([], accumulator), do: accumulator
  defp get_num_valid_pass_count([head | tail], accumulator) do
    {{min_occur, max_occur}, letter, pass} = head

    count = count_letter(pass, letter, 0)

    if count >= min_occur and count <= max_occur do
      get_num_valid_pass_count(tail, accumulator + 1)
    else
      get_num_valid_pass_count(tail, accumulator)
    end
  end

  defp count_letter(<<>>, _, accumulator), do: accumulator
  defp count_letter(<<l::utf8, rest::binary>>, l, accumulator) do
    count_letter(rest, l, accumulator + 1)
  end
  defp count_letter(<<_::utf8, rest::binary>>, l, accumulator) do
    count_letter(rest, l, accumulator)
  end

  # Part 2 logic
  defp get_num_valid_pass_pos([], accumulator), do: accumulator
  defp get_num_valid_pass_pos([head | tail], accumulator) do
    {targets, letter, pass} = head

    if letter_at_target?(pass, targets, letter, 1, false) do
      get_num_valid_pass_pos(tail, accumulator + 1)
    else
      get_num_valid_pass_pos(tail, accumulator)
    end

  end

  defp letter_at_target?(<<>>, _, _, _, met), do: met
  defp letter_at_target?(<<l::utf8, rest::binary>>, {t1, t2}, l, t1, _) do
    letter_at_target?(rest, {t1, t2}, l, t1 + 1, true)
  end
  defp letter_at_target?(<<l::utf8, _::binary>>, {_, t2}, l, t2, true), do: false
  defp letter_at_target?(<<l::utf8, _::binary>>, {_, t2}, l, t2, false), do: true
  defp letter_at_target?(<<_::utf8, rest::binary>>, targets, l, curr_pos, met) do
      letter_at_target?(rest, targets, l, curr_pos + 1, met)
  end
end
