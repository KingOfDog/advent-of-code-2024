defmodule AdventOfCode.Day13 do
  def part1(args) do
    args
    |> parse()
    |> Enum.map(&solve/1)
    |> Enum.filter(fn {x, y} -> x <= 100 and y <= 100 end)
    |> Enum.filter(fn {x, y} -> x == round(x) && y == round(y) end)
    |> Enum.map(fn {x, y} -> 3 * round(x) + round(y) end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse()
    |> Enum.map(fn [ax, ay, bx, by, px, py] ->
      [ax, ay, bx, by, px + 10_000_000_000_000, py + 10_000_000_000_000]
    end)
    |> Enum.map(&solve/1)
    |> Enum.filter(fn {x, y} -> x == round(x) && y == round(y) end)
    |> Enum.map(fn {x, y} -> 3 * round(x) + round(y) end)
    |> Enum.sum()
  end

  defp parse(args) do
    args
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn x ->
      Regex.scan(~r"\d+", x) |> Enum.concat() |> Enum.map(&(Integer.parse(&1) |> elem(0)))
    end)
  end

  defp solve([ax, ay, bx, by, px, py]) do
    c = ax * by - ay * bx
    d = px * by - py * bx
    e = ax * py - ay * px

    x = d / c
    y = e / c

    {x, y}
  end
end
