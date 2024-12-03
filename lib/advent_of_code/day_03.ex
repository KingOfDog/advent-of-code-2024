defmodule AdventOfCode.Day03 do
  def part1(args) do
    Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, args)
    |> Enum.map(fn [_, a, b] -> mul(a, b) end)
    |> Enum.sum()
  end

  def part2(args) do
    Regex.scan(~r/do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)/, args)
    |> Enum.reduce({true, 0}, fn match, {enabled, sum} ->
      case match do
        ["do()"] ->
          {true, sum}

        ["don't()"] ->
          {false, sum}

        [_, a, b] ->
          if enabled do
            {enabled, sum + mul(a, b)}
          else
            {enabled, sum}
          end
      end
    end)
    |> elem(1)
  end

  def mul(a, b) do
    (Integer.parse(a) |> elem(0)) * (Integer.parse(b) |> elem(0))
  end
end
