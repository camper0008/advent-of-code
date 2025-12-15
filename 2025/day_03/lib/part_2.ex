defmodule Part2 do
  @spec max_joltage([integer], [integer], integer) :: integer
  defp max_joltage(_input, items, _current) when length(items) == 12 do
    items |> Enum.reverse() |> Enum.map(fn x -> "#{x}" end) |> Enum.join() |> String.to_integer()
  end

  @spec max_joltage([integer], [integer], integer) :: integer
  defp max_joltage(input, items, current) do
    idx = Enum.find_index(input, fn x -> x == current end)

    if idx != nil do
      remaining_input = length(Enum.drop(input, idx))
      required_input = 12 - length(items)

      if required_input <= remaining_input do
        max_joltage(Enum.drop(input, idx + 1), [current | items], 9)
      else
        max_joltage(input, items, current - 1)
      end
    else
      if current == 1 do
        raise "unreachable: contract violated"
      end

      max_joltage(input, items, current - 1)
    end
  end

  @spec max_joltage([integer]) :: integer
  defp max_joltage(input) do
    max_joltage(input, [], 9)
  end

  @spec solve([[integer]], integer) :: integer
  defp solve(input, score) do
    case input do
      [bank | tail] ->
        score = score + max_joltage(bank)
        solve(tail, score)

      [] ->
        score
    end
  end

  @spec solve([[integer]]) :: integer
  defp solve(input) do
    solve(input, 0)
  end

  def main() do
    input = Utils.prepare_input!("input.txt")

    IO.puts(solve(input))
  end
end
