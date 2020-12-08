defmodule Day7 do

  def part1() do
    bag_graph = :digraph.new

    load_data(bag_graph)

    contain_set = get_containing_bags(bag_graph, ["shiny gold"], MapSet.new)
    MapSet.size contain_set
  end

  def part2() do
    bag_graph = :digraph.new

    quant_map = load_data(bag_graph)

    IO.inspect(quant_map)

    get_all_bags_inside(bag_graph, quant_map, ["shiny gold"], 0)
  end

  defp load_data(graph) do
    File.stream!("inputs/day7.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&(String.trim_trailing(&1, ".")))
    |> Stream.map(&(add_line_to_vars(graph, &1)))
    |> Enum.reduce(&(Map.merge(&1, &2)))
  end


  # Part 1
  # Adds nodes to the digraph and adds to the quantity insides for a node
  defp add_line_to_vars(graph, line) do
    [outside, insides] = line
    |> String.split("bags contain", trim: true)
    |> Enum.map(&String.trim/1)

    insides = insides
    |> String.replace("bags", "")
    |> String.replace("bag", "")
    |> String.split(",", trim: true)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&get_bag_info/1)

    inside_map = Enum.reduce(insides, Map.new, fn {quantity, bag_name}, acc -> Map.put(acc, bag_name, quantity) end)

    insides = Enum.map(insides, fn {_, bag_name} -> bag_name end)

    # Add vertices and edges
    add_vertex(graph, outside)
    Enum.each(insides, fn bag_name ->
      add_vertex(graph, bag_name)
      :digraph.add_edge(graph, outside, bag_name)
    end)

    %{outside => inside_map}
  end

  defp get_bag_info(quantity_bag_desc) do
    matches = Regex.run(~r"^(\d)+\ (.*)$", quantity_bag_desc)
    case matches do
      [_, num, type] -> {String.to_integer(num), type}
      _ -> {:nil, :nil}
    end
  end

  defp add_vertex(graph, v) do
    if :digraph.vertex(graph, v) == false do
      :digraph.add_vertex(graph, v)
    end

    nil
  end

  defp get_containing_bags(_graph, [], acc_set), do: acc_set
  defp get_containing_bags(graph, [bag | process_bags], acc_set) do
    containing_bags = :digraph.in_neighbours(graph, bag)
    containing_set = MapSet.new(containing_bags)
    get_containing_bags(graph, containing_bags ++ process_bags, MapSet.union(acc_set, containing_set))
  end

  # Part 2
  defp get_all_bags_inside(_graph, _quant_map, [], acc), do: acc
  defp get_all_bags_inside(graph, quant_map, [bag | process_bags], acc) do
    bags_inside = :digraph.out_neighbours(graph, bag)


    total_inside = bags_inside
    # |> inspect_stream()
    |> Stream.map(fn in_bag -> quant_map[bag][in_bag] end)
    |> Stream.filter(fn
      nil -> false
      _ -> true
    end)
    |> Enum.sum

    get_all_bags_inside(graph, quant_map, bags_inside ++ process_bags, acc + total_inside)
  end

  def inspect_stream(stream) do
    stream
    |> Enum.to_list()
    |> IO.inspect()

    stream
  end

end
