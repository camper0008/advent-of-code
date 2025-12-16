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

    if depth > 0 do
      solve([lhs, rhs] ++ without, depth - 1)
    else
      junctions
    end
  end

  defp build_circuits(x) do
    build_circuits(x, x)
  end

  defp build_circuits(junction = %JunctionC{}, lookup = [%JunctionC{} | _]) do
    theirconns = lookup |> Enum.filter(fn x -> x.junction in junction.conns end)
    IO.inspect(theirconns)
  end

  def main() do
    junctions = Utils.prepare_input!("input.example.txt")

    junctions = solve(junctions, 10)

    junctions
    |> Enum.map(fn x -> build_circuits(x, junctions) end)
    |> IO.inspect()

    "hello"
  end
end
