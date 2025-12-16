defmodule Part1 do
  defp solve(
         junctions = [%JunctionC{} | _],
         depth
       ) do
    {lhs, rhs} =
      Utils.permutations(junctions)
      |> Enum.filter(fn {lhs, rhs} ->
        rhs.junction not in lhs.conns and lhs.junction not in rhs.conns
      end)
      |> Enum.min_by(fn {lhs, rhs} -> Junction.dist(lhs.junction, rhs.junction) end)

    without =
      junctions
      |> Enum.filter(&(&1 != lhs and &1 != rhs))

    lhs = JunctionC.connect(lhs, rhs)

    if rem(depth, 10) == 0 do
      IO.inspect(depth)
    end

    if depth > 0 do
      solve([lhs, rhs] ++ without, depth - 1)
    else
      junctions
    end
  end

  defp build_circuits(junction = %JunctionC{}, lookup = [%JunctionC{} | _], filter) do
    lookup = for x <- lookup, x.junction not in filter, do: x

    theirconns =
      lookup
      |> Enum.filter(fn x -> x.junction in junction.conns and x.junction not in filter end)
      |> Enum.flat_map(&build_circuits(&1, lookup, [junction.junction | filter]))

    theirconns2 =
      lookup
      |> Enum.filter(fn x -> junction.junction in x.conns and junction.junction not in filter end)
      |> Enum.flat_map(&build_circuits(&1, lookup, [junction.junction | filter]))

    if rem(length(filter), 10) == 0 do
      IO.inspect(length(filter))
    end

    conc = junction.conns ++ theirconns ++ theirconns2
    [junction.junction | conc] |> Enum.uniq()
  end

  def main() do
    junctions = Utils.prepare_input!("input.txt")

    junctions =
      solve(junctions, 1000)

    junctions
    |> Enum.map(fn x -> build_circuits(x, junctions, []) end)
    |> Enum.map(&Enum.sort(&1))
    |> Enum.sort(&(length(&1) > length(&2)))
    |> Enum.uniq()
    |> Enum.map(&length(&1))
    |> Enum.take(3)
    |> Enum.reduce(&(&1 * &2))
    |> IO.inspect()
  end
end
