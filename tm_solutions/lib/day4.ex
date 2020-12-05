defmodule Day4 do

  def part1 do
    load_data_stream()
    |> Stream.map(&line_to_map/1)
    |> Stream.chunk_while(%{}, &chunk_fn/2, &after_fn/1)
    |> Stream.filter(&valid_passport?/1)
    |> Enum.count
  end

  def part2 do
    load_data_stream()
    |> Stream.map(&line_to_map/1)
    |> Stream.chunk_while(%{}, &chunk_fn/2, &after_fn/1)
    |> Stream.filter(&valid_complete_passport?/1)
    |> Enum.count
  end

  defp load_data_stream do
    File.stream!("inputs/day4.txt", line_or_bytes: :line)
    |> Stream.map(&String.trim/1)
  end

  # Part 1 Logic
  defp line_to_map(line) when byte_size(line) == 0, do: %{}
  defp line_to_map(line) do
    line
    |> String.split(" ")
    |> Enum.map(fn kp ->
      [key, val] = String.split(kp, ":")
      %{key => val}
    end)
    |> Enum.reduce(%{}, fn kv, acc -> Map.merge(kv, acc) end)
  end

  # Combines lines (currently maps) that are not separated by an empty map
  defp chunk_fn(element, acc) when map_size(element) == 0, do: {:cont, acc, %{}}
  defp chunk_fn(element, acc), do: {:cont, Map.merge(element, acc)}

  defp after_fn(acc) when map_size(acc) == 0, do: {:cont, %{}}
  defp after_fn(acc), do: {:cont, acc, %{}}

  @required_keys ~w(byr iyr eyr hgt hcl ecl pid)

  defp valid_passport?(passport) do
    Enum.all?(@required_keys, fn key -> Map.has_key?(passport, key) end)
  end

  # Part 2 Logic
  defp valid_complete_passport?(passport) do
    valid_attrs? = Enum.all?(Map.keys(passport), fn key -> valid_attr?(key, passport[key]) end)
    valid_passport?(passport) and valid_attrs?
  end

  defp is_four_dig?(val) do
    val =~ ~r"^\d{4}$"
  end

  defp valid_attr?("byr", val) do
    is_four_dig?(val) and String.to_integer(val) in 1920..2002
  end

  defp valid_attr?("iyr", val) do
    is_four_dig?(val) and String.to_integer(val) in 2010..2020
  end

  defp valid_attr?("eyr", val) do
    is_four_dig?(val) and String.to_integer(val) in 2020..2030
  end

  defp valid_attr?("hgt", val) do
    matches = Regex.run(~r"^(\d+)(cm|in)$", val)
    case matches do
      [_, num, "cm"] -> String.to_integer(num) in 150..193
      [_, num, "in"] -> String.to_integer(num) in 59..76
      _ -> false
    end
  end

  defp valid_attr?("hcl", val) do
    val =~ ~r"^#[0-9a-f]{6}$"
  end

  defp valid_attr?("ecl", val) do
    val in ~w(amb blu brn gry grn hzl oth)
  end

  defp valid_attr?("pid", val) do
    val =~ ~r"^\d{9}$"
  end

  defp valid_attr?(_, _), do: true

end
