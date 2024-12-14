defmodule AdventOfCode.Day11 do
  def part1(args) do
    args
    |> parse()
    |> count_stones_after_iterations(25)
  end

  defp parse(args) do
    args
    |> String.split()
    |> Enum.map(fn n -> Integer.parse(n) |> elem(0) end)
    |> Enum.frequencies()
  end

  defp count_stones_after_iterations(stones, iters) do
    stones
    |> Stream.iterate(&update_stones/1)
    |> Stream.drop(iters)
    |> Stream.take(1)
    |> Enum.to_list()
    |> List.last()
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  defp update_stones(stones) do
    stones
    |> Enum.flat_map(fn {x, count} ->
      update_stone(x) |> Enum.map(&{&1, count})
    end)
    |> Enum.reduce(Map.new(), fn {x, count}, map ->
      Map.update(map, x, count, &(&1 + count))
    end)
  end

  defp update_stone(stone)
       when stone == 0 do
    [1]
  end

  defp update_stone(stone) do
    len = (Math.log10(stone) |> floor()) + 1

    case rem(len, 2) == 0 do
      true ->
        half = Integer.floor_div(len, 2)
        pow = Math.pow(10, half)
        [Integer.floor_div(stone, pow), rem(stone, pow)]

      false ->
        [stone * 2024]
    end
  end

  def part2(args) do
    args |> parse() |> count_stones_after_iterations(75)
  end
end
