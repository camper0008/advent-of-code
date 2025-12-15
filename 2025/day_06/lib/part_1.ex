defmodule Part1 do
  @spec solve([{[integer], UtilsPart1.operation()}]) :: integer
  defp solve(input) do
    input
    |> Enum.map(fn {input, type} ->
      case type do
        :mul -> Enum.reduce(input, fn x, y -> x * y end)
        :plus -> Enum.reduce(input, fn x, y -> x + y end)
      end
    end)
    |> Enum.sum()
  end

  def main() do
    input = UtilsPart1.prepare_input!("input.txt")

    IO.puts(solve(input))
  end
end
