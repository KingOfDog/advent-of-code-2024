defmodule Mix.Tasks.D07.P2 do
  use Mix.Task

  import AdventOfCode.Day07

  @shortdoc "Day 07 Part 2"
  @spec run(any()) :: Benchee.Suite.t()
  def run(args) do
    input = AdventOfCode.Input.get!(7, 2024)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
