defmodule Day11 do

  def part1() do
    load_data()
    |> elem(1)
    |> do_rounds
    |> count
  end

  def part2() do
    load_data()
    |> elem(1)
    |> do_rounds(true)
    |> count
  end

  defp load_data() do
    File.stream!("inputs/day11.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&row_to_map/1)
    |> Enum.reduce({0, %{}}, &to_map_reduction/2)
  end

  defp row_to_map(row_str) do
    to_charlist(row_str)
    |> Stream.map(&char_to_sym/1)
    |> Enum.reduce({0, %{}}, &to_map_reduction/2)
    |> elem(1)
  end

  defp to_map_reduction(element, {ind, map}) do
    new_map = Map.put(map, ind, element)
    {ind+1, new_map}
  end

  defp char_to_sym(char) do
    case char do
      ?. -> :floor
      ?# -> :occupied
      ?L -> :empty
    end
  end

  defp get_val(map, row, col) do
    row_map = Map.get(map, row)
    if row_map do
      Map.get(row_map, col)
    end
  end

  defp set_val(map, row, col, val) do
    row_map = Map.get(map, row)
    if row_map && col < map_size(row_map)  do
      new_row = Map.put(row_map, col, val)
      Map.put(map, row, new_row)
    end
  end

  # Part 1
  defp do_rounds(state, extended? \\ false, count \\ 0) do
    row_size = map_size state
    col_size = map_size Map.get(state, 0)

    {new_state, modified?} = do_round(state, row_size-1, col_size-1, extended?)
    if modified? do
      do_rounds(new_state, extended?, count+1)
    else
      new_state
    end
  end

  defp do_round(state, max_row, max_col, extended?) do
    do_round(state, max_row, max_col, {0,0}, state, false, extended?)
  end

  defp do_round(state, max_row, max_col, {curr_row, curr_col}, new_state, modified?, extended?) do
    val = get_val(state, curr_row, curr_col)

    {n_count, vis_threshold} = if extended? do
      {extended_occupied_neigbors(state, curr_row, curr_col), 5}
    else
      {occupied_neighbors(state, curr_row, curr_col), 4}
    end

    {new_state, changed?} = cond do
      val == :empty and n_count == 0 -> {set_val(new_state, curr_row, curr_col, :occupied), true}
      val == :occupied and n_count >= vis_threshold -> {set_val(new_state, curr_row, curr_col, :empty), true}
      true -> {new_state, false}
    end

    # Update modifed? flag if there was a change made to seating
    modified? = if !modified? and changed?, do: true, else: modified?

    # Check curr_row and curr_col to determine next step
    new_pos = if curr_col == max_col, do: {curr_row+1, 0}, else: {curr_row, curr_col+1}
    if elem(new_pos, 0) > max_row do
      {new_state, modified?}
    else
      do_round(state, max_row, max_col, new_pos, new_state, modified?, extended?)
    end
  end

  defp occupied_neighbors(map, row, col) do
    [{-1,1}, {0,1}, {1,1}, {-1,0}, {1,0}, {-1,-1}, {0,-1}, {1,-1}]
    |> Stream.map(fn {dx, dy} -> get_val(map, row+dy, col+dx) end)
    |> Enum.count(&(&1 == :occupied))
  end

  defp count(map, val \\ :occupied) do
    map
    |> Map.to_list
    |> Stream.map(fn {_, row} -> row end)
    |> Stream.map(&Map.to_list/1)
    |> Stream.flat_map(fn row -> Enum.map(row, fn {_, seat_state} -> seat_state end) end)
    |> Enum.count(&(&1 == val))
  end

  # Part 2
  defp extended_occupied_neigbors(map, row, col) do
    [{-1,1}, {0,1}, {1,1}, {-1,0}, {1,0}, {-1,-1}, {0,-1}, {1,-1}]
    |> Stream.map(fn {dx, dy} -> get_next_in_dir(map, {dx, dy}, row, col) end)
    |> Enum.count(&(&1 == :occupied))
  end

  defp get_next_in_dir(map, {dx, dy}, row, col) do
    val = get_val(map, row+dy, col+dx)
    case val do
      :floor -> get_next_in_dir(map, {dx, dy}, row+dy, col+dx)
      _ -> val
    end
  end

end
