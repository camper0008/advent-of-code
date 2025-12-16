defmodule Part1 do
  defp permutations([_]) do
    []
  end

  defp permutations([junction | tail]) do
    Enum.concat(tail |> Enum.map(fn other -> {junction, other} end), permutations(tail))
  end

  @spec filter_junction_pairs(
          [{Junction, Junction}],
          [Junction]
        ) :: [{Junction, Junction}]
  defp filter_junction_pairs(
         pairs = [{%Junction{}, %Junction{}} | _],
         pair = [%Junction{} | _]
       ) do
    pairs
    |> Enum.filter(fn {lhs, rhs} ->
      lhs not in pair and rhs not in pair
    end)
  end

  @spec squash_junction_pairs([{Junction, Junction}]) :: [{Junction}]
  defp squash_junction_pairs(pairs = [{%Junction{}, %Junction{}} | _]) do
    pairs
    |> Enum.flat_map(&Tuple.to_list/1)
    |> Enum.uniq()
  end

  defp solve(
         junctions = [%Junction{} | _],
         [] = _circuits,
         depth
       ) do
    [closest | tail] =
      permutations(junctions)
      |> Enum.map(fn {lhs, rhs} -> {{lhs, rhs}, Junction.dist(lhs, rhs)} end)
      |> Enum.sort(fn {_, lhs}, {_, rhs} -> lhs < rhs end)
      |> Enum.map(fn {pair, _} -> pair end)

    closest = Tuple.to_list(closest)

    junction_tail =
      filter_junction_pairs(tail, closest)
      |> squash_junction_pairs()

    solve(junction_tail, [%Circuit{parts: closest}], depth - 1)
  end

  defp solve(
         junctions = [%Junction{} | _],
         circuits = [%Circuit{} | _],
         depth
       )
       when depth == 0 do
    [junctions, circuits]
  end

  defp solve(
         junctions = [%Junction{} | _],
         circuits = [%Circuit{} | _],
         depth
       ) do
    [{closest_junction, junction_dist} | junction_tail] =
      permutations(junctions)
      |> Enum.map(fn {lhs, rhs} -> {{lhs, rhs}, Junction.dist(lhs, rhs)} end)
      |> Enum.sort(fn {_, lhs}, {_, rhs} -> lhs < rhs end)

    [{{closest_circuit_junction, closest_circuit = %Circuit{}}, circuit_dist} | circuit_tail] =
      circuits
      |> Enum.flat_map(fn circuit ->
        Enum.map(junctions, fn junction ->
          {{junction, circuit}, Circuit.dist(circuit, junction)}
        end)
      end)
      |> Enum.sort(fn {_, lhs}, {_, rhs} -> lhs < rhs end)

    cond do
      junction_dist < circuit_dist ->
        closest_junction = Tuple.to_list(closest_junction)

        junction_tail =
          junction_tail
          |> Enum.map(fn {x, _dist} -> x end)
          |> filter_junction_pairs(closest_junction)
          |> squash_junction_pairs()

        solve(
          junction_tail,
          [%Circuit{parts: closest_junction} | circuits],
          depth - 1
        )

      junction_dist > circuit_dist ->
        junction_tail =
          junction_tail
          |> Enum.map(fn {x, _dist} -> x end)
          |> filter_junction_pairs([closest_circuit_junction])
          |> squash_junction_pairs()

        circuit_tail =
          circuit_tail
          |> Enum.map(fn {{_junction, circuit}, _dist} -> circuit end)

        circuit_tail = [
          %Circuit{closest_circuit | parts: [closest_circuit_junction | closest_circuit.parts]}
          | circuit_tail
        ]

        solve(
          junction_tail,
          circuit_tail,
          depth - 1
        )

      true ->
        raise "contract violated"
    end
  end

  def main() do
    junction = Utils.prepare_input!("input.example.txt")

    x = solve(junction, [], 10)
    IO.inspect(x)
  end
end
