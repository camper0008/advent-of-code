defmodule Utils do
  @spec parse_range(String.t()) :: {integer, integer}
  defp parse_range(range) do
    [start, last] = String.split(range, "-", trim: true) |> Enum.map(&String.to_integer/1)

    {start, last}
  end

  @spec prepare_input!(String.t()) :: {[{integer, integer}], [integer]}
  def prepare_input!(filename) when is_binary(filename) do
    {:ok, content} = File.read(filename)

    lines =
      content
      |> String.split("\n", trim: true)

    ranges =
      lines
      |> Enum.take_while(fn x -> "-" in String.split(x, "") end)
      |> Enum.map(&parse_range/1)

    ingredients =
      lines
      |> Enum.drop_while(fn x -> "-" in String.split(x, "") end)
      |> Enum.map(&String.to_integer/1)

    {ranges, ingredients}
  end
end
