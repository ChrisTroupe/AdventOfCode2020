defmodule Day12 do

  def part1() do
    {x, y, _} = load_data()
    |> Enum.reduce({0,0,0}, &run_instr/2)

    round abs(x) + abs(y)
  end

  def part2() do
    {x, y, _, _} = load_data()
    |> Enum.reduce({0,0,10,1}, &run_way_instr/2)

    round abs(x) + abs(y)
  end

  def load_data() do
    File.stream!("inputs/day12.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn instr ->
      matches = Regex.run(~r"(\w)(\d+)", instr)
      case matches do
        [_, dir, quant] -> {dir, String.to_integer(quant)}
        _ -> {:nil, :nil}
      end
    end)
  end

  # Part 1 - angle is in radians
  defp run_instr({"N", quant}, {x, y, angle}), do: {x, y+quant, angle}
  defp run_instr({"S", quant}, {x, y, angle}), do: {x, y-quant, angle}
  defp run_instr({"E", quant}, {x, y, angle}), do: {x+quant, y, angle}
  defp run_instr({"W", quant}, {x, y, angle}), do: {x-quant, y, angle}
  defp run_instr({"F", quant}, {x, y, angle}) do
    dx = quant * :math.cos(angle)
    dy = quant * :math.sin(angle)

    {x+dx, y+dy, angle}
  end
  defp run_instr({"L", quant}, {x, y, angle}) do
    {x, y, angle + to_radians(quant)}
  end
  defp run_instr({"R", quant}, {x, y, angle}) do
    {x, y, angle - to_radians(quant)}
  end

  defp to_radians(degrees) do
    degrees * :math.pi / 180
  end

  # Part 2
  defp run_way_instr({"N", quant}, {ship_x, ship_y, way_x, way_y}) do
    {ship_x, ship_y, way_x, way_y + quant}
  end
  defp run_way_instr({"S", quant}, {ship_x, ship_y, way_x, way_y}) do
    {ship_x, ship_y, way_x, way_y - quant}
  end
  defp run_way_instr({"E", quant}, {ship_x, ship_y, way_x, way_y}) do
    {ship_x, ship_y, way_x + quant, way_y}
  end
  defp run_way_instr({"W", quant}, {ship_x, ship_y, way_x, way_y}) do
    {ship_x, ship_y, way_x - quant, way_y}
  end
  defp run_way_instr({"F", quant}, {ship_x, ship_y, way_x, way_y}) do
    dx = quant * way_x
    dy = quant * way_y

    {ship_x + dx, ship_y + dy, way_x, way_y}
  end
  defp run_way_instr({"L", quant}, {ship_x, ship_y, way_x, way_y}) do
    s = :math.sin to_radians(quant)
    c = :math.cos to_radians(quant)

    new_way_x = c * way_x - s * way_y
    new_way_y = s * way_x + c * way_y

    {ship_x, ship_y, new_way_x, new_way_y}
  end
  defp run_way_instr({"R", quant}, {ship_x, ship_y, way_x, way_y}) do
    s = :math.sin to_radians(quant)
    c = :math.cos to_radians(quant)

    new_way_x = c * way_x + s * way_y
    new_way_y = -1 * s * way_x + c * way_y

    {ship_x, ship_y, new_way_x, new_way_y}
  end

end
