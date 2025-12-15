defmodule Part1 do
  @spec solve({[integer], [integer]}) :: integer
  defp solve({ranges, ingredients}) do
    ingredients
    |> Enum.filter(fn id ->
      Enum.any?(ranges, fn {start, last} ->
        id >= start and id <= last
      end)
    end)
    |> Enum.count()
  end

  def main() do
    input = Utils.prepare_input!("input.txt")

    IO.puts(solve(input))
  end
end
