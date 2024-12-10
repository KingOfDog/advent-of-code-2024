defmodule AdventOfCode.Day04 do
  def part1(args) do
    lines =
      String.split(args)
      |> Enum.map(fn line -> String.to_charlist(line) end)

    horizontal = lines
    verticals = transpose(lines)
    diagonals = find_diagonals(lines)

    (horizontal ++ verticals ++ diagonals)
    |> Enum.map(fn line ->
      Enum.chunk_every(line, 4, 1, leftover: :discard)
      |> Enum.count(fn chars -> chars == ~C"XMAS" || chars == ~C"SAMX" end)
    end)
    |> Enum.sum()
  end

  defp transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp find_diagonals(matrix) do
    chars_with_index =
      matrix
      |> Stream.with_index()
      |> Enum.flat_map(fn {row, y} ->
        row |> Stream.with_index() |> Enum.map(fn {c, x} -> {c, x, y} end)
      end)

    diagonals =
      chars_with_index
      |> Enum.group_by(fn {_, x, y} -> x + y end)
      |> Enum.map(fn {_, line} ->
        line
        |> Enum.map(fn {c, _, _} -> c end)
      end)

    diagonals_back =
      chars_with_index
      |> Enum.group_by(fn {_, x, y} -> y - x end)
      |> Enum.map(fn {_, line} ->
        line
        |> Enum.map(fn {c, _, _} -> c end)
      end)

    diagonals ++ diagonals_back
  end

  def part2(args) do
    String.split(args)
    |> Enum.map(fn line -> String.to_charlist(line) end)
    |> sliding_windows()
    |> Enum.count(fn x -> check_xmas(x) end)
  end

  defp check_xmas(chunk) do
    find_diagonals(chunk)
    |> Enum.filter(fn line -> length(line) == 3 end)
    |> Enum.all?(fn line -> line == ~c"MAS" or line == ~c"SAM" end)
  end

  defp sliding_windows(matrix) do
    rows = length(matrix)
    cols = length(List.first(matrix))

    for y <- 0..(rows - 3), x <- 0..(cols - 3) do
      get_window(matrix, x, y)
    end
  end

  defp get_window(matrix, x, y) do
    matrix |> Enum.slice(y, 3) |> Enum.map(fn row -> Enum.slice(row, x, 3) end)
  end
end
