defmodule Part1 do
  @spec neighbours([{integer, integer}], {integer, integer}) :: integer
  defp neighbours(input, {x, y}) do
    neighbours = [
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1},
      {x, y - 1},
      {x, y + 1}
    ]

    neighbours
    |> Enum.filter(fn nb -> Enum.member?(input, nb) end)
    |> Enum.count()
  end

  @spec solve([{integer, integer}]) :: integer
  defp solve(input) do
    input |> Enum.filter(fn pos -> neighbours(input, pos) < 4 end) |> Enum.count()
  end

  def main() do
    input = Utils.prepare_input!("input.example.txt")

    IO.puts(solve(input))
  end
end
