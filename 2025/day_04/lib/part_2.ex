defmodule Part2 do
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

  @spec solve([{integer, integer}], integer) :: integer
  defp solve(input, count \\ 0) do
    to_remove =
      input
      |> Enum.filter(fn pos -> neighbours(input, pos) < 4 end)

    amount_to_remove = to_remove |> Enum.count()

    if amount_to_remove > 0 do
      solve(
        input |> Enum.filter(fn pos -> pos not in to_remove end),
        count + amount_to_remove
      )
    else
      count
    end
  end

  def main() do
    input = Utils.prepare_input!("input.txt")

    IO.puts(solve(input))
  end
end
