defmodule Day5 do

  def part1() do
    load_data()
    |> Stream.map(&get_seat_pos/1)
    |> Stream.map(&get_seat_id/1)
    |> Enum.max
  end

  def part2() do
    load_data()
    |> Stream.map(&get_seat_pos/1)
    |> Stream.map(&get_seat_id/1)
    |> Enum.sort
    |> Stream.scan({}, &scan_fn/2)
    |> Stream.filter(fn {_, prev_exists?} -> not prev_exists? end)
    |> Stream.map(fn {id, _} -> id-1 end)
    |> Enum.at(0)
  end

  def load_data() do
    File.stream!("inputs/day5.txt")
    |> Stream.map(&String.trim/1)
  end

  # Part 1
  defp get_seat_id({row_pos, col_pos}) do
    8 * row_pos + col_pos
  end

  def get_seat_pos(boarding_pass) do
    {row_desc, col_desc} = String.split_at(boarding_pass, 7)
    row_num = binary_steps(row_desc, {?F, ?B}, 0, 127)
    col_num = binary_steps(col_desc, {?L, ?R}, 0, 7)

    {row_num, col_num}
  end

  defp binary_steps("", _chars, min, min), do: min
  defp binary_steps("", _chars, _min, max), do: max
  defp binary_steps(<<low_char::utf8, steps::binary>>, {low_char, high_char}, min, max) do
    binary_steps(steps, {low_char, high_char}, min, min + div(max-min, 2))
  end
  defp binary_steps(<<high_char::utf8, steps::binary>>, {low_char, high_char}, min, max) do
    binary_steps(steps, {low_char, high_char}, min + div(max-min, 2), max)
  end

  # Part 2
  defp scan_fn(element, {}), do: {element, true}
  defp scan_fn(element, {prev_elem, _prev_exists?}), do: {element, element == prev_elem + 1}

end
