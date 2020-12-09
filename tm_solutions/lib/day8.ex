defmodule Day8 do

  def part1() do
    {instructions, _, _} = load_data()
    acc_at_loop(instructions)
  end

  def part2() do
    {instructions, nop_lines, jmp_lines} = load_data()
    # Try jmp
    jmp_res = check_instr(instructions, jmp_lines, "nop")
    # Try nop
    nop_res = check_instr(instructions, nop_lines, "jmp")
    cond do
      jmp_res -> jmp_res
      nop_res -> nop_res
    end
  end

  defp load_data() do
    File.stream!("inputs/day8.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&(String.split(&1, " ")))
    |> Stream.map(fn [instr, val] -> {instr, String.to_integer(val)} end)
    |> Enum.reduce({%{}, [], [], 0}, fn instr, {instr_map, nop_lines, jmp_lines, line} ->
      instr_map = Map.put(instr_map, line, instr)

      case elem(instr, 0) do
        "nop" -> {instr_map, [line | nop_lines], jmp_lines, line+1}
        "jmp" -> {instr_map, nop_lines, [line | jmp_lines], line+1}
        _ -> {instr_map, nop_lines, jmp_lines, line+1}
      end
    end)
    |> (fn {instructions, nop_lines, jmp_lines, _} -> {instructions, nop_lines, jmp_lines} end).()
  end

  # Part 1
  defp acc_at_loop(instructions) do
    acc_at_loop(instructions, 0, MapSet.new, 0)
  end
  defp acc_at_loop(instructions, line, executed_set, acc) do
    instr = instructions[line]
    executed_set = MapSet.put(executed_set, line)
    {next_line, new_acc} = execute_instr(instr, line, acc)
    if MapSet.member?(executed_set, next_line) do
      acc
    else
      acc_at_loop(instructions, next_line, executed_set, new_acc)
    end
  end

  # instr is {"acc", 1} or {"jmp", -99}
  # returns {next_instr_line, acc}
  defp execute_instr(instr, curr_line, acc) do
    case instr do
      {"acc", val} -> {curr_line + 1, acc + val}
      {"jmp", val} -> {curr_line + val, acc}
      _ -> {curr_line + 1, acc}
    end
  end


  # Part 2
  defp check_instr(instructions, instr_lines, sub_instr)
  defp check_instr(_, [], _), do: nil
  defp check_instr(instructions, [line | rest], sub_instr) do
    {_, val} = instructions[line]
    # Substitue instruction
    new_instructions = Map.put(instructions, line, {sub_instr, val})

    # Get acc at end of loop, if it exists
    case loop_value(new_instructions, 0, MapSet.new, 0) do
      nil -> check_instr(instructions, rest, sub_instr)
      val -> val
    end
  end

  defp loop_value(instructions, line, executed_set, acc) do
    instr = instructions[line]
    executed_set = MapSet.put(executed_set, line)
    {next_line, new_acc} = execute_instr(instr, line, acc)
    cond do
      MapSet.member?(executed_set, next_line) -> nil
      instr == nil -> new_acc
      true -> loop_value(instructions, next_line, executed_set, new_acc)
    end
  end


end
