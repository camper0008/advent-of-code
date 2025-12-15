defmodule Part2 do
  @spec schmove({:up | :down, integer}, integer, integer) :: {integer, integer}
  defp schmove(schmoves, input, count) do
    case schmoves do
      {:up, value} ->
        input = if input == 99, do: 0, else: input + 1
        count = if input == 0, do: count + 1, else: count

        if value == 1 do
          {input, count}
        else
          schmove({:up, value - 1}, input, count)
        end

      {:down, value} ->
        input = if input == 0, do: 99, else: input - 1
        count = if input == 0, do: count + 1, else: count

        if value == 1 do
          {input, count}
        else
          schmove({:down, value - 1}, input, count)
        end
    end
  end

  @spec calc([{:up | :down, integer}], integer, integer) :: integer
  defp calc(schmoves, input, count) do
    case schmoves do
      [{:up, value} | tail] ->
        {input, count} = schmove({:up, value}, input, count)

        calc(tail, input, count)

      [{:down, value} | tail] ->
        {input, count} = schmove({:down, value}, input, count)

        calc(tail, input, count)

      [] ->
        count
    end
  end

  def main() do
    schmoves = Utils.prepare_input!("input.txt")

    IO.puts(calc(schmoves, 50, 0))
  end
end
