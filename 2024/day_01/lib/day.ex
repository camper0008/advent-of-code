defmodule Part1 do
  @spec min_sum([integer], [integer], integer) :: integer
  defp min_sum(left, right, initial_sum) do
    len = length(left) + length(right)

    cond do
      len > 0 ->
        min_left = Enum.min(left)
        min_right = Enum.min(right)
        diff = abs(min_left - min_right)
        min_sum(left -- [min_left], right -- [min_right], initial_sum + diff)

      true ->
        initial_sum
    end
  end

  def main() do
    {left, right} = Utils.prepare_input!("input.txt")

    IO.puts(min_sum(left, right, 0))
  end
end

defmodule Part2 do
  @spec similarity_score_unit(integer(), [integer()]) :: integer()
  defp similarity_score_unit(value, values) do
    score = Enum.reduce(values, 0, fn right, acc -> acc + if right == value, do: 1, else: 0 end)
    value * score
  end

  @spec similarity_score([integer()], [integer()]) :: integer()
  defp similarity_score(left, right) do
    Enum.reduce(left, 0, fn v, acc -> acc + similarity_score_unit(v, right) end)
  end

  def main() do
    {left, right} = Utils.prepare_input!("input.txt")

    IO.puts(similarity_score(left, right))
  end
end

defmodule Day do
  def main do
    Part1.main()
    Part2.main()
  end
end
