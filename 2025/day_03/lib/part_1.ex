defmodule Part1 do
  @spec major_idx!([integer], integer) :: non_neg_integer
  defp major_idx!(input, major) do
    major_idx = Enum.find_index(input, fn x -> x == major end)

    if major_idx == nil do
      raise "unreachable: contract violated"
    end

    major_idx
  end

  @spec max_joltage([integer], integer, integer) :: integer
  defp max_joltage(input, major, minor) do
    is_valid =
      Enum.member?(input, major) and
        input |> Enum.drop(major_idx!(input, major) + 1) |> Enum.member?(minor)

    cond do
      is_valid ->
        String.to_integer("#{major}#{minor}")

      major == 1 and minor == 1 ->
        raise "unreachable: contract violated"

      minor == 1 ->
        max_joltage(input, major - 1, 9)

      true ->
        max_joltage(input, major, minor - 1)
    end
  end

  @spec max_joltage([integer]) :: integer
  defp max_joltage(input) do
    max_joltage(input, 9, 9)
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
