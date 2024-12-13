defmodule AdventOfCode.Day09 do
  def part1(args) do
    {files, free} = parse(args)
    checksum(defrag(Enum.reverse(files), free))
  end

  def part2(args) do
    {files, free} = parse(args)
    checksum(move(Enum.reverse(files), free))
  end

  def parse(input) do
    String.trim(input)
    |> String.to_charlist()
    |> Stream.scan({0, {:free, 0, 0}}, fn
      c, {fileno, {:free, off, count}} ->
        {fileno + 1, {:file, fileno, off + count, c - ?0}}

      c, {fileno, {:file, _, off, len}} ->
        {fileno, {:free, off + len, c - ?0}}
    end)
    |> Stream.map(&elem(&1, 1))
    |> Enum.split_with(&(elem(&1, 0) == :file))
  end

  def checksum(l) do
    Enum.reduce(l, 0, fn {:file, fileno, off, len}, acc ->
      acc + fileno * div(len * (len - 1 + 2 * off), 2)
    end)
  end

  def defrag(files, []), do: files
  def defrag([], _), do: []

  def defrag(files = [{:file, _, file_idx, _} | _], [{:free, free_idx, _} | _])
      when free_idx >= file_idx,
      do: files

  def defrag(files, [{:free, _, 0} | frees]), do: defrag(files, frees)

  def defrag([{:file, fileno, _, len} | files], [{:free, free_idx, count} | frees])
      when count >= len,
      do: [
        {:file, fileno, free_idx, len}
        | defrag(files, [{:free, free_idx + len, count - len} | frees])
      ]

  def defrag([{:file, fileno, file_idx, len} | files], [{:free, free_idx, count} | frees]),
    do: [
      {:file, fileno, free_idx, count}
      | defrag([{:file, fileno, file_idx, len - count} | files], frees)
    ]

  @spec move([{:file, any(), any(), any()}], any()) :: [{:file, any(), any(), any()}]
  def move([], _), do: []

  def move([file = {:file, fileno, file_idx, len} | files], free) do
    case find_free(free, len, []) do
      {bef, {:free, free_idx, count}, aft} when free_idx < file_idx ->
        [
          {:file, fileno, free_idx, len}
          | move(files, bef ++ [{:free, free_idx + len, count - len}] ++ aft)
        ]

      _ ->
        [file | move(files, free)]
    end
  end

  def find_free([], _, _), do: nil

  def find_free([free = {:free, _, count} | aft], len, bef) when count >= len,
    do: {Enum.reverse(bef), free, aft}

  def find_free([f | aft], len, bef), do: find_free(aft, len, [f | bef])
end
