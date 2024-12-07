defmodule Main do
  def split_and_integerify(value) do
    [left, right] = String.split(value, " ", trim: true)
    {left, _rest} = Integer.parse(left)
    {right, _rest} = Integer.parse(right)
    {left, right}
  end

  def min_sum(left, right, initial_sum) do
    len = length(left) + length(right);
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
    {:ok, content} = File.read("input.txt")
    content = String.split(content, "\n", trim: true);
    content = Enum.map(content, 
      fn st -> split_and_integerify(st) 
    end)
    {left, right} = Enum.unzip(content)
    IO.puts(min_sum(left, right, 0))
  end
end

Main.main()
