defmodule AdventOfCode.Day05 do
  def part1(args) do
    [rules, instructions] = parse(args)

    instructions
    |> Enum.filter(fn line -> is_valid(rules, line) end)
    |> Enum.map(fn line -> middle_element(line) end)
    |> Enum.sum()
  end

  def part2(args) do
    [rules, instructions] = parse(args)

    instructions
    |> Enum.filter(fn line -> not is_valid(rules, line) end)
    |> Enum.map(fn line -> build_correct_order(rules, line) end)
    |> Enum.map(fn line -> middle_element(line) end)
    |> Enum.sum()
  end

  defp is_valid(rules, instructions) do
    instructions
    |> Stream.with_index()
    |> Enum.all?(fn {x, i} ->
      need_to_be_after = Map.get(rules, x, [])

      not (Enum.slice(instructions, 0..i)
           |> Enum.any?(fn y -> Enum.member?(need_to_be_after, y) end))
    end)
  end

  defp build_correct_order(rules, line) do
    Enum.reduce(line, [], fn instruction, partial ->
      insert_at_correct_pos(rules, partial, instruction, length(partial))
    end)
  end

  defp insert_at_correct_pos(rules, line, element, index) do
    candidate = List.insert_at(line, index, element)

    case is_valid(rules, candidate) do
      true -> candidate
      false -> insert_at_correct_pos(rules, line, element, index - 1)
    end
  end

  defp middle_element(line) do
    Enum.at(line, Integer.floor_div(length(line), 2))
  end

  defp parse(input) do
    [rules, updates] = String.split(input, "\n\n")

    rules =
      rules
      |> String.split()
      |> Enum.map(fn line ->
        String.split(line, "|")
        |> Enum.map(fn x -> Integer.parse(x) |> elem(0) end)
        |> List.to_tuple()
      end)
      |> Enum.group_by(fn {first, _} -> first end, fn {_, second} -> second end)

    updates =
      updates
      |> String.split()
      |> Enum.map(fn line ->
        String.split(line, ",") |> Enum.map(fn x -> Integer.parse(x) |> elem(0) end)
      end)

    [rules, updates]
  end
end
