defmodule AdventOfCode.Day01 do
  def part1(args) do
    parse(args)
    |> Enum.map(fn x -> Enum.sort(x) end)
    |> Enum.zip()
    |> Enum.map(fn {x, y} -> abs(x - y) end)
    |> Enum.sum()
  end

  def part2(args) do
    [left, right] = parse(args)

    occurences =
      Enum.frequencies(right)

    left
    |> Enum.map(fn x -> Map.get(occurences, x, 0) * x end)
    |> Enum.sum()
  end

  def parse(args) do
    String.split(args)
    |> Enum.map(fn x -> Integer.parse(x) |> elem(0) end)
    |> Stream.with_index()
    |> Enum.reduce([[], []], fn {x, i}, [left, right] ->
      case rem(i, 2) do
        0 -> [left ++ [x], right]
        _ -> [left, right ++ [x]]
      end
    end)
  end
end
