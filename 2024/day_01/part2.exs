defmodule Main do
  def split_and_integerify(value) do
    [left, right] = String.split(value, " ", trim: true)
    {left, _rest} = Integer.parse(left)
    {right, _rest} = Integer.parse(right)
    {left, right}
  end

  def similarity_score_unit(value, values) do
    score = Enum.reduce(values, 0, fn right, acc -> acc + if right == value, do: 1, else: 0 end)
    value * score
  end

  def similarity_score(left, right) do
    Enum.reduce(left, 0, fn v, acc -> acc + similarity_score_unit(v, right) end)
  end

  def main() do
    {:ok, content} = File.read("input.txt")
    content = String.split(content, "\n", trim: true);
    content = Enum.map(content, 
      fn st -> split_and_integerify(st) 
    end)
    {left, right} = Enum.unzip(content)
    IO.puts(similarity_score(left, right))
  end
end

Main.main()
