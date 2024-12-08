defmodule Utils do
  def parse!(string) do
    {int, _} = Integer.parse(string)
    int
  end

  def extract_information(line) do
    [value, operands] = line |> String.split(":", trim: true)
    value = value |> parse!()
    operands = operands |> String.split(" ", trim: true) |> Enum.map(fn x -> parse!(x) end)
    {value, operands}
  end

  def combine(left, right) do
    left = left |> Integer.to_string()
    right = right |> Integer.to_string()
    combined = left <> right
    parse!(combined)
  end
end

defmodule Main do
  def run_thru_operands(operands) do
    case operands do
      [left, right] ->
        [left + right, left * right, Utils.combine(right, left)]

      [left | right] ->
        results = run_thru_operands(right)
        sum = results |> Enum.map(fn v -> left + v end)
        product = results |> Enum.map(fn v -> left * v end)
        combined = results |> Enum.map(fn v -> Utils.combine(v, left) end)
        sum ++ product ++ combined
    end
  end

  def find_valid_values({value, operands}) do
    run_thru_operands(operands |> Enum.reverse())
    |> Enum.any?(fn v -> v == value end)
  end

  def main() do
    {:ok, content} = File.read("input.txt")

    content
    |> String.split("\n")
    |> Enum.map(&Utils.extract_information/1)
    |> Enum.filter(&Main.find_valid_values/1)
    |> Enum.map(fn {value, _} -> value end)
    |> Enum.sum()
    |> IO.inspect(charlists: :as_lists)
  end
end

Main.main()
