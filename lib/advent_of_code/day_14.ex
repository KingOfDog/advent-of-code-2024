defmodule AdventOfCode.Day14 do
  def part1(args, size) do
    iters = 100

    parse(args)
    |> move(iters, size)
    |> security_score(size)
  end

  def part2(args, {width, height}) do
    robots = parse(args)
    count = length(robots)

    1..(width * height)
    |> Enum.find(fn iters ->
      unique = move(robots, iters, {width, height}) |> MapSet.new()
      MapSet.size(unique) == count
    end)
  end

  defp parse(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      Regex.scan(~r"\-?\d+", line) |> Enum.concat() |> Enum.map(&(Integer.parse(&1) |> elem(0)))
    end)
    |> Enum.map(fn [x, y, vx, vy] -> {{x, y}, {vx, vy}} end)
  end

  defp move(robots, iters, {width, height}) do
    robots
    |> Enum.map(fn {{x, y}, {vx, vy}} ->
      {mod(x + iters * vx, width), mod(y + iters * vy, height)}
    end)
  end

  defp security_score(positions, {width, height}) do
    mid_x = (width - 1) / 2
    mid_y = (height - 1) / 2

    positions
    |> Enum.filter(fn {x, y} -> x != mid_x and y != mid_y end)
    |> Enum.map(fn {x, y} ->
      if x < mid_x do
        if y < mid_y do
          0
        else
          2
        end
      else
        if y < mid_y do
          1
        else
          3
        end
      end
    end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.product()
  end

  defp mod(x, y) do
    rem(rem(x, y) + y, y)
  end
end
