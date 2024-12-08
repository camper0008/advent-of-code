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
end

defmodule Main do
  def run_thru_operands(operands) do
    IO.inspect(operands, label: "operands", charlists: :as_lists)

    case operands do
      [left, right] ->
        [left + right, left * right]

      [left | right] ->
        results =
          run_thru_operands(right)
          |> IO.inspect(label: "results", charlists: :as_lists)

        sum = results |> Enum.map(fn v -> left + v end)
        product = results |> Enum.map(fn v -> left * v end)
        sum ++ product
    end
  end

  def find_valid_values({value, operands}) do
    IO.inspect(value, label: "value")

    run_thru_operands(operands |> Enum.reverse())
    |> IO.inspect(charlists: :as_lists)
    |> Enum.any?(fn v -> v == value end)
  end

  def main() do
    {:ok, content} = File.read("input.txt")

    lines =
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
