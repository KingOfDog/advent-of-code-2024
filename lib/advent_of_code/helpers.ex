defmodule AdventOfCode.Helpers do
  def string_rows_to_chars(string) do
    string
    |> String.split()
    |> Enum.map(fn line -> String.to_charlist(line) end)
  end

  def grid_to_choords(array) do
    array
    |> Enum.with_index(fn row, y ->
      row
      |> Enum.with_index(fn c, x -> {{x, y}, c - ?0} end)
    end)
    |> Enum.concat()
    |> Map.new()
  end
end
