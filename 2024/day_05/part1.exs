defmodule Utils do
  def parse!(string) do
    {int, _} = Integer.parse(string)
    int
  end
end

defmodule Main do
  def entry_after_is_valid(page, entry, rules) do
    aft =
      rules
      |> Enum.filter(fn {x, _} -> x == entry end)
      |> Enum.map(fn {_, x} -> x end)
      |> IO.inspect(label: "after: rules", charlists: :as_lists)

    # Checks if a entry in `after` appears before `entry`
    page
    |> Enum.take_while(fn x -> x != entry end)
    |> IO.inspect(label: "after: check", charlists: :as_lists)
    |> Enum.all?(fn num ->
      aft
      |> Enum.find(fn aft ->
        num == aft
      end) == nil
    end)
  end

  @doc """
  Takes a `List<int>`, `int` and `List<{before, after}`
  Returns `List<{before, after}>`
  """
  def entry_is_valid(page, entry, rules) do
    IO.inspect(entry, label: "entry")

    entry_after_is_valid(page, entry, rules)
  end

  def page_is_valid(page, rules) do
    page
    |> Enum.all?(fn entry -> entry_is_valid(page, entry, rules) end)
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

  def main() do
    {:ok, content} = File.read("input.txt")

    [rules, pages] =
      String.split(content, "\n\n", trim: true)

    rules = rules |> generate_rulebook()

    pages
    |> String.split("\n")
    |> Enum.map(&Main.page_to_numbers/1)
    |> Enum.filter(fn page -> page_is_valid(page, rules) end)
    |> IO.inspect(label: "pass", charlists: :as_lists)
    |> Enum.map(&Main.middle/1)
    |> Enum.sum()
    |> IO.inspect(charlists: :as_lists)
  end
end

Main.main()
