defmodule TM do
  @moduledoc """
  Documentation for `TM`.
  """

  def get_multiple_from_file(name, num) when is_bitstring(name) do
    {:ok, contents} = File.read(name)
    num_list = contents
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    if num == 2 do
      get_multiple(num_list)
    else
      get_multiple_3(num_list)
    end
  end

  def get_multiple(num_list) when is_list(num_list) do
    {num1, num2} = get_matching_nums(num_list, 2020)
    if num1 && num2 do
      IO.puts num1 * num2
      num1 * num2
    else
      IO.puts "Could not find a result"
      nil
    end
  end

  def get_multiple_3(num_list) when is_list(num_list) do
    {num1, num2, num3} = find_matching_pair(num_list)
    if num1 && num2 && num3 do
      IO.puts num1 * num2 * num3
      num1 * num2 * num3
    else
      IO.puts "Could not find a result"
      nil
    end
  end

  defp get_matching_nums([], _), do: {nil, nil}
  defp get_matching_nums([head | tail], goal) do
    result = get_matching_num(head, tail, goal)
    if result do
      {head, result}
    else
      get_matching_nums(tail, goal)
    end
  end

  defp get_matching_num(_, [], _), do: nil
  defp get_matching_num(base, [head | tail], goal) do
    if base + head == goal do
      head
    else
      get_matching_num(base, tail, goal)
    end
  end

  defp find_matching_pair([]), do: {nil, nil, nil}
  defp find_matching_pair([head | tail]) do
    goal = 2020 - head
    {num1, num2} = get_matching_nums(tail, goal)
    if num1 && num2 do
      {head, num1, num2}
    else
      find_matching_pair(tail)
    end
  end

end
