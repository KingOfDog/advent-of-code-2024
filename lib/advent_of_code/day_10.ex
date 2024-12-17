defmodule AdventOfCode.Day10 do
  def part1(args) do
    coords = args |> parse()
    trailheads = coords |> find_trailheads()

    trailheads
    |> Enum.map(&trace_path(coords, &1))
    |> Enum.map(&Enum.uniq/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  def part2(args) do
    coords = args |> parse()
    trailheads = coords |> find_trailheads()

    trailheads
    |> Enum.map(&trace_path(coords, &1))
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  defp trace_path(coords, pos) do
    if coords[pos] == 9 do
      [pos]
    else
      {x, y} = pos

      Stream.iterate({0, -1}, fn {dx, dy} ->
        {-dy, dx}
      end)
      |> Stream.take(4)
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.filter(&Map.has_key?(coords, &1))
      |> Enum.filter(&(coords[&1] - coords[pos] == 1))
      |> Enum.map(&trace_path(coords, &1))
      |> Enum.concat()
    end
  end

  defp parse(args) do
    args
    |> AdventOfCode.Helpers.string_rows_to_chars()
    |> AdventOfCode.Helpers.grid_to_choords()
  end

  defp find_trailheads(coords) do
    coords
    |> Map.filter(fn {_, value} -> value == 0 end)
    |> Map.keys()
  end
end
