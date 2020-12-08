defmodule Day7 do

  def part1() do
    insides_map = load_data()
    |> Stream.map(&convert_line_to_map/1)
    |> Enum.reduce(&(Map.merge(&1, &2, fn
      _k, v1, v2 -> v1 ++ v2
    end)))

    insides_map[:nil]
  end

  def load_data() do
    File.stream!("inputs/day7.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&(String.trim_trailing(&1, ".")))
  end


  # Part 1
  def convert_line_to_map(line) do
    [outside, insides] = line
    |> String.split("bags contain", trim: true)
    |> Enum.map(&String.trim/1)

    insides
    |> String.replace("bags", "")
    |> String.replace("bag", "")
    |> String.split(",", trim: true)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&get_bag_info/1)
    |> Stream.map(fn {_, type} -> %{type => [outside]} end)
    |> Enum.reduce(&Map.merge/2)
  end

  def get_bag_info(quantity_bag_desc) do
    matches = Regex.run(~r"^(\d)+\ (.*)$", quantity_bag_desc)
    case matches do
      [_, num, type] -> {String.to_integer(num), type}
      _ -> {:nil, :nil}
    end
  end

  def inspect_stream(stream) do
    stream
    |> Enum.to_list
    |> IO.inspect

    stream
  end

end
