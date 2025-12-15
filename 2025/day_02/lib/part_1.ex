defmodule Part1 do
  @spec calc([{integer, integer}], integer) :: integer
  defp calc(ranges, count) do
    case ranges do
      [{start, stop} | tail] ->
        str = "#{start}"

        if rem(String.length(str), 2) != 0 do
          if start == stop do
            calc(tail, count)
          else
            calc([{start + 1, stop} | tail], count)
          end
        else
          half_length = round(String.length(str) / 2)
          left = String.slice(str, 0, half_length)
          right = String.slice(str, half_length, half_length)

          count = if left == right, do: count + start, else: count

          if start == stop do
            calc(tail, count)
          else
            calc([{start + 1, stop} | tail], count)
          end
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
