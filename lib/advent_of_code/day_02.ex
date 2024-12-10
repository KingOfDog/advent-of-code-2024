defmodule AdventOfCode.Day02 do
  def part1(args) do
    args
    |> String.split("\n")
    |> Enum.count(fn line ->
      numbers = String.split(line) |> Enum.map(fn x -> Integer.parse(x) |> elem(0) end)

      diffs =
        Enum.chunk_every(numbers, 2, 1, :discard)
        |> Enum.map(fn [a, b] -> b - a end)

      increasing_or_decreasing =
        Enum.all?(diffs, fn x -> x < 0 end) or Enum.all?(diffs, fn x -> x > 0 end)

      at_most_three = Enum.all?(diffs, fn x -> abs(x) <= 3 end)

      not Enum.empty?(numbers) and increasing_or_decreasing and at_most_three
    end)
  end

  def part2(args) do
    args
    |> String.split("\n")
    |> Enum.count(fn line ->
      numbers = String.split(line) |> Enum.map(fn x -> Integer.parse(x) |> elem(0) end)

      options =
        [numbers] ++
          (numbers
           |> Stream.with_index()
           |> Enum.map(fn {_x, i} -> List.delete_at(numbers, i) end))

      Enum.any?(options, fn list ->
        diffs =
          Enum.chunk_every(list, 2, 1, :discard)
          |> Enum.map(fn [a, b] -> b - a end)

        increasing_or_decreasing =
          Enum.all?(diffs, fn x -> x < 0 end) or Enum.all?(diffs, fn x -> x > 0 end)

        at_most_three = Enum.all?(diffs, fn x -> abs(x) <= 3 end)

        not Enum.empty?(list) and increasing_or_decreasing and at_most_three
      end)
    end)
  end
end
