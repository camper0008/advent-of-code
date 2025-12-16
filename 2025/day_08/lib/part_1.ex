defmodule Part1 do
  defp solve(
         circuits = [%Circuit{} | _],
         depth
       ) do
    tree =
      Utils.permutations(circuits)
      |> Enum.filter(fn {lhs, rhs} ->
        length(lhs.parts) == 1 or length(rhs.parts) == 1
      end)

    {{closest_lhs, closest_rhs}, _} =
      tree
      |> Enum.map(fn {lhs, rhs} -> {{lhs, rhs}, Circuit.dist(lhs, rhs)} end)
      |> Enum.min_by(fn {_, dist} -> dist end)

    without =
      circuits
      |> Enum.filter(&(&1 != closest_lhs and &1 != closest_rhs))

    closest = Circuit.merge(closest_lhs, closest_rhs)

    if depth >= 0 do
      solve([closest | without], depth - 1)
    else
      circuits
    end
  end

  def main() do
    circuits = Utils.prepare_input!("input.example.txt")

    circuits = solve(circuits, 10)

    circuits =
      circuits
      |> Enum.sort(&(length(&1.parts) > length(&2.parts)))
      |> IO.inspect()

    circuits =
      circuits
      |> Enum.map(&length(&1.parts))
      |> Enum.sort(&(&1 > &2))
      |> Enum.take(3)
      |> Enum.reduce(&(&1 * &2))
      |> IO.inspect()

    "hello"
  end
end
