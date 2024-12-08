defmodule Utils do
  def parse!(string) do
    {int, _} = Integer.parse(string)
    int
  end

  @doc """
  Returns `List<int>`
  """
  def page_to_numbers(page) do
    page
    |> String.split(",")
    |> Enum.map(&Utils.parse!/1)
  end

  def middle(list) do
    idx = div(length(list), 2)
    list |> Enum.at(idx)
  end

  @doc """
  Returns `List<{before, after}>`
  """
  def generate_rulebook(rules) do
    rules
    |> String.split("\n")
    |> Enum.map(fn v ->
      [bef, aft] =
        String.split(v, "|")
        |> Enum.map(&Utils.parse!/1)

      {bef, aft}
    end)
  end
end

defmodule Main do
  @doc """
  Takes a `List<int>`, `int` and `List<{before, after}`
  Returns `List<{before, after}>`
  """
  def entry_is_valid(page, entry, rules) do
    aft =
      rules
      |> Enum.filter(fn {x, _} -> x == entry end)
      |> Enum.map(fn {_, x} -> x end)

    # Checks if a entry in `after` appears before `entry`
    page
    |> Enum.take_while(fn x -> x != entry end)
    |> Enum.all?(fn num ->
      aft
      |> Enum.find(fn aft ->
        num == aft
      end) == nil
    end)
  end

  def page_is_valid(page, rules) do
    page
    |> Enum.all?(fn entry -> entry_is_valid(page, entry, rules) end)
  end

  def reorder_with_rules(page, rules) do
    page
  end

  def main() do
    {:ok, content} = File.read("input.txt")

    [rules, pages] =
      String.split(content, "\n\n", trim: true)

    rules = rules |> Utils.generate_rulebook()

    pages
    |> String.split("\n")
    |> Enum.map(&Utils.page_to_numbers/1)
    |> Enum.filter(fn page -> !page_is_valid(page, rules) end)
    |> Enum.map(fn page -> reorder_with_rules(page, rules) end)
    |> Enum.map(&Utils.middle/1)
    |> Enum.sum()
    |> IO.inspect(charlists: :as_lists)
  end
end

Main.main()
