defmodule AdventOfCode.Day07 do
  def part1(args) do
    String.split(args, "\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn line ->
      [target, operands] = String.split(line, ":")
      operands = String.split(operands) |> Enum.map(&Integer.parse/1) |> Enum.map(&elem(&1, 0))

      target = Integer.parse(target) |> elem(0)

      {target, operands}
    end)
    |> Enum.filter(fn {target, ops} ->
      find_possible_results(ops) |> Enum.member?(target)
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def find_possible_results(operands) do
    operands
    |> IO.inspect()
    |> Enum.reduce([], fn x, acc ->
      if Enum.empty?(acc) do
        [x]
      else
        Enum.map(acc, &(&1 + x)) ++
          Enum.map(acc, &(&1 * x))
      end
    end)
  end

  def part2(args) do
    String.split(args, "\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn line ->
      [target, operands] = String.split(line, ":")
      operands = String.split(operands) |> Enum.map(&Integer.parse/1) |> Enum.map(&elem(&1, 0))

      target = Integer.parse(target) |> elem(0)

      {target, operands}
    end)
    |> Enum.filter(fn {target, ops} ->
      find_possible_results2(ops, target)
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def find_possible_results2(operands, target) do
    operands
    |> Enum.reduce([], fn x, acc ->
      if Enum.empty?(acc) do
        [x]
      else
        Enum.map(acc, &(&1 + x)) ++
          Enum.map(acc, &(&1 * x)) ++
          Enum.map(acc, &concatenate(&1, x))
      end
    end)
    |> Enum.any?(&(&1 == target))
  end

  defp concatenate(a, b) do
    (Integer.to_string(a) <> Integer.to_string(b)) |> Integer.parse() |> elem(0)
  end
end
