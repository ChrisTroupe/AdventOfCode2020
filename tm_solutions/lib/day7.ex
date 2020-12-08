defmodule Day7 do

  @quantity_map Map.new

  def part1() do
    bag_graph = :digraph.new

    load_data()
    |> Enum.each(&(add_line_to_vars(bag_graph, &1)))

    contain_set = get_containing_bags(bag_graph, ["shiny gold"], MapSet.new)
    MapSet.size contain_set
  end

  def load_data() do
    File.stream!("inputs/day7.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&(String.trim_trailing(&1, ".")))
  end


  # Part 1
  # Adds nodes to the digraph and adds to the quantity insides for a node
  def add_line_to_vars(graph, line) do
    [outside, insides] = line
    |> String.split("bags contain", trim: true)
    |> Enum.map(&String.trim/1)

    insides = insides
    |> String.replace("bags", "")
    |> String.replace("bag", "")
    |> String.split(",", trim: true)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&get_bag_info/1)

    Map.put(@quantity_map, outside, insides)

    insides = Enum.map(insides, fn {_, bag_name} -> bag_name end)

    # Add vertices and edges
    add_vertex(graph, outside)
    Enum.each(insides, fn bag_name ->
      add_vertex(graph, bag_name)
      :digraph.add_edge(graph, outside, bag_name)
    end)

    nil
  end

  def add_vertex(graph, v) do
    if :digraph.vertex(graph, v) == false do
      :digraph.add_vertex(graph, v)
    end

    nil
  end

  def get_containing_bags(_graph, [], acc_set), do: acc_set
  def get_containing_bags(graph, [bag | process_bags], acc_set) do
    containing_bags = :digraph.in_neighbours(graph, bag)
    containing_set = MapSet.new(containing_bags)
    get_containing_bags(graph, containing_bags ++ process_bags, MapSet.union(acc_set, containing_set))
  end

  def get_bag_info(quantity_bag_desc) do
    matches = Regex.run(~r"^(\d)+\ (.*)$", quantity_bag_desc)
    case matches do
      [_, num, type] -> {String.to_integer(num), type}
      _ -> {:nil, :nil}
    end
  end

end
