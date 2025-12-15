defmodule Part2 do
  @spec solve({[integer], UtilsPart2.operation()}) :: integer
  defp solve({numbers, op}) do
    case op do
      :mul -> numbers |> Enum.reduce(fn x, acc -> x * acc end)
      :plus -> numbers |> Enum.reduce(fn x, acc -> x + acc end)
    end
  end

  @spec solve([{[integer], UtilsPart2.operation()}]) :: integer
  defp solve(input) do
    input
    |> Enum.map(&solve/1)
    |> Enum.sum()
  end

  def main() do
    input = UtilsPart2.prepare_input!("input.txt")

    IO.puts(solve(input))
  end
end
