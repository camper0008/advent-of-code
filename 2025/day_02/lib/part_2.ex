defmodule Part2 do
  @spec is_invalid(String.t(), integer) :: boolean()
  defp is_invalid(str, pattern_length) do
    if pattern_length > String.length(str) / 2 do
      false
    else
      pattern = String.slice(str, 0, pattern_length) |> String.codepoints()

      matches =
        String.codepoints(str)
        |> Enum.chunk_every(pattern_length)
        |> Enum.map(fn slice -> slice == pattern end)
        |> Enum.all?()

      if matches do
        true
      else
        is_invalid(str, pattern_length + 1)
      end
    end
  end

  @spec calc([{integer, integer}], integer) :: integer
  defp calc(ranges, count) do
    case ranges do
      [{start, stop} | tail] ->
        count = if is_invalid("#{start}", 1), do: count + start, else: count

        if start == stop do
          calc(tail, count)
        else
          calc([{start + 1, stop} | tail], count)
        end

      [] ->
        count
    end
  end

  def main() do
    ranges = Utils.prepare_input!("input.txt")

    IO.puts(calc(ranges, 0))
  end
end
