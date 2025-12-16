defmodule Part2 do
  defp evaluate({:start, pos}, map, accumulated) do
    evaluate({:blank, pos}, map, accumulated)
  end

  defp evaluate({:blank, {x, y}}, map, accumulated) do
    next = Enum.find(map, fn {_, pos} -> pos == {x, y + 1} end)

    if next != nil do
      evaluate(next, map, accumulated)
    else
      {0, accumulated}
    end
  end

  @spec evaluate(Utils.item(), [Utils.item()], map()) :: [{integer(), integer()}]
  defp evaluate({:split, {x, y}}, map, accumulated) do
    cached = Map.get(accumulated, {x, y})

    if cached != nil do
      {cached, accumulated}
    else
      left = Enum.find(map, fn {_, pos} -> pos == {x - 1, y} end)
      {left, accumulated} = evaluate(left, map, accumulated)

      right = Enum.find(map, fn {_, pos} -> pos == {x + 1, y} end)
      {right, accumulated} = evaluate(right, map, accumulated)

      accumulated = Map.put(accumulated, {x, y}, left + right + 1)

      {left + right + 1, accumulated}
    end
  end

  @spec solve([Utils.item()]) :: integer()
  defp solve(input) do
    start = Enum.find(input, fn {op, _} -> op == :start end)

    {complexity, _} =
      evaluate(start, input, Map.new())

    complexity + 1
  end

  def main() do
    input =
      Utils.prepare_input!("input.txt")

    IO.puts(solve(input))
  end
end
