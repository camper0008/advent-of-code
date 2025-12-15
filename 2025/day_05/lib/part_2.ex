defmodule Part2 do
  @type range() :: {integer(), integer()}

  @spec merge(range(), range()) ::
          range() | :no_merge
  defp merge({start0, stop0}, {start1, stop1}) do
    cond do
      start0 == start1 and stop0 == stop1 ->
        {start0, stop0}

      start0 in start1..stop1 and start0 != start1 ->
        merge({start1, stop0}, {start1, stop1})

      start1 in start0..stop0 and start0 != start1 ->
        merge({start0, stop0}, {start0, stop1})

      stop0 in start1..stop1 and stop0 != stop1 ->
        merge({start0, stop1}, {start1, stop1})

      stop1 in start0..stop0 and stop0 != stop1 ->
        merge({start0, stop0}, {start1, stop0})

      true ->
        :no_merge
    end
  end

  @spec merge(range(), [range()], [range()]) :: [range()]
  defp merge(rhs, [], discarded) do
    [rhs | discarded]
  end

  @spec merge(range(), [range()], [range()]) :: [range()]
  defp merge(rhs, [lhs | tail], discarded) do
    case merge(rhs, lhs) do
      :no_merge -> merge(rhs, tail, [lhs | discarded])
      rhs -> merge(rhs, tail, discarded)
    end
  end

  @spec count([range()]) :: integer
  defp count(ranges) do
    ranges |> Enum.map(fn {start, stop} -> stop - start + 1 end) |> Enum.sum()
  end

  defp solve(input) do
    input
    |> Enum.reduce(input, fn prime, slack ->
      merge(prime, slack, [])
    end)
    |> count
  end

  def main() do
    {ranges, _ingredients} = Utils.prepare_input!("input.txt")

    IO.puts(solve(ranges))
  end
end
