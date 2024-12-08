defmodule AdventOfCode.Day06 do
  def part1(args) do
    {obstacles, start} = parse(args)

    trace_path_to_completion(obstacles, start) |> Enum.count()
  end

  def part2(args) do
    {obstacles, start} = parse(args)

    regular_path =
      trace_path_to_completion(obstacles, start)

    Enum.count(regular_path, &has_loop?(Map.put(obstacles, &1, ?#), start))
  end

  defp has_loop?(coords, guard_pos) do
    trace_path(coords, guard_pos)
    |> Stream.take_while(&Map.has_key?(coords, elem(&1, 0)))
    |> contains_dup?()
  end

  defp parse(args) do
    lines =
      String.split(args)
      |> Enum.map(&String.to_charlist/1)

    grid =
      lines
      |> Enum.with_index(fn line, y ->
        line |> Enum.with_index(fn value, x -> {{x, y}, value} end)
      end)
      |> Enum.concat()
      |> Map.new()

    start = Enum.find(grid, fn {_key, value} -> value == ?^ end) |> elem(0)

    {grid, start}
  end

  defp trace_path_to_completion(obstacles, guard_pos) do
    trace_path(obstacles, guard_pos)
    |> Stream.map(&elem(&1, 0))
    |> Stream.uniq()
    |> Stream.take_while(&Map.has_key?(obstacles, &1))
  end

  defp trace_path(obstacles, guard_pos) do
    Stream.iterate({guard_pos, {0, -1}}, fn {{guard_x, guard_y}, {dir_x, dir_y}} ->
      {dir_x, dir_y} =
        Stream.iterate({dir_x, dir_y}, fn {x, y} -> {-y, x} end)
        |> Enum.find(fn {x, y} -> obstacles[{guard_x + x, guard_y + y}] != ?# end)

      {{guard_x + dir_x, guard_y + dir_y}, {dir_x, dir_y}}
    end)
  end

  def contains_dup?(enumerable) do
    enumerable
    |> Enum.reduce_while(MapSet.new(), fn x, acc ->
      if x in acc, do: {:halt, :contains_dup}, else: {:cont, MapSet.put(acc, x)}
    end) == :contains_dup
  end
end
