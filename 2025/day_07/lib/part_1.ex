defmodule Part1 do
  defp evaluate({:start, pos}, map, accumulated) do
    evaluate({:blank, pos}, map, accumulated)
  end

  defp evaluate({:blank, {x, y}}, map, accumulated) do
    next = Enum.find(map, fn {_, pos} -> pos == {x, y + 1} end)

    if next != nil do
      evaluate(next, map, [{:blank, {x, y}} | accumulated])
    else
      accumulated
    end
  end

  @spec evaluate(Utils.item(), [Utils.item()], [Utils.item()]) :: [{integer(), integer()}]
  defp evaluate({:split, {x, y}}, map, accumulated) do
    accumulated = [{:split, {x, y}} | accumulated]
    left = Enum.find(map, fn {_, pos} -> pos == {x - 1, y} end)
    right = Enum.find(map, fn {_, pos} -> pos == {x + 1, y} end)

    accumulated =
      if left not in accumulated,
        do: evaluate(left, map, accumulated),
        else: accumulated

    accumulated =
      if right != nil and right not in accumulated,
        do: evaluate(right, map, accumulated),
        else: accumulated

    accumulated
  end

  @spec solve([Utils.item()]) :: integer()
  defp solve(input) do
    start = Enum.find(input, fn {op, _} -> op == :start end)

    evaluate(start, input, [])
    |> Enum.uniq()
    |> Enum.filter(fn {op, _} -> op == :split end)
    |> Enum.count()
  end

  def main() do
    input =
      Utils.prepare_input!("input.example.txt")

    IO.puts(solve(input))
  end
end
