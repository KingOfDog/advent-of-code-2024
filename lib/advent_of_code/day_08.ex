defmodule AdventOfCode.Day08 do
  def part1(args) do
    {coords, frequencies} = parse(args)

    frequencies
    |> Enum.flat_map(fn {_, antennas} ->
      antennas
      |> Enum.flat_map(fn {ax, ay} ->
        antennas
        |> List.delete({ax, ay})
        |> Enum.map(fn {bx, by} ->
          {dx, dy} = {bx - ax, by - ay}
          {ax - dx, ay - dy}
        end)
      end)
    end)
    |> Enum.filter(&Map.has_key?(coords, &1))
    |> Enum.uniq()
    |> Enum.count()
  end

  defp parse(args) do
    coords =
      args
      |> parse_grid()
      |> grid_to_coords()

    frequencies =
      coords
      |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
      |> Map.delete(?.)

    coords = coords |> Map.new()

    {coords, frequencies}
  end

  defp parse_grid(string) do
    string
    |> String.split()
    |> Enum.map(&String.to_charlist/1)
  end

  defp grid_to_coords(grid) do
    grid
    |> Enum.with_index(fn row, y ->
      row
      |> Enum.with_index(fn c, x ->
        {{x, y}, c}
      end)
    end)
    |> Enum.concat()
  end

  def part2(args) do
    {coords, frequencies} = parse(args)

    frequencies
    |> Stream.flat_map(fn {_, antennas} ->
      antennas
      |> Stream.flat_map(fn {ax, ay} ->
        antennas
        |> List.delete({ax, ay})
        |> Stream.flat_map(fn {bx, by} ->
          {dx, dy} = {bx - ax, by - ay}

          Stream.iterate({ax, ay}, fn {x, y} -> {x - dx, y - dy} end)
          |> Stream.take_while(&Map.has_key?(coords, &1))
        end)
      end)
    end)
    |> Stream.uniq()
    |> Enum.count()
  end
end
