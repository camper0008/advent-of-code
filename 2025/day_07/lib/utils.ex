defmodule Utils do
  @type operation() :: :start | :blank | :split

  @type pos() :: {operation(), {integer, integer}}

  @type item() :: {operation(), pos()}

  @spec parse_line({String.t(), integer()}) :: [item()]
  def parse_line({line, y}) do
    line
    |> String.codepoints()
    |> Enum.map(fn x ->
      case x do
        "S" -> :start
        "." -> :blank
        "^" -> :split
      end
    end)
    |> Enum.with_index()
    |> Enum.map(fn {op, x} -> {op, {x, y}} end)
  end

  @spec prepare_input!(String.t()) :: [item()]
  def prepare_input!(filename) when is_binary(filename) do
    {:ok, content} = File.read(filename)

    content
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(&Utils.parse_line/1)
  end
end
