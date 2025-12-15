defmodule Utils do
  @spec split(String.t()) :: [integer]
  def split(value) do
    value
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.filter(fn {value, _idx} -> value == "@" end)
    |> Enum.map(fn {_value, idx} -> idx end)
  end

  @spec coalesce({[integer], integer}) :: {integer, integer}
  def coalesce({list, y}) do
    list |> Enum.map(fn x -> {x, y} end)
  end

  @spec prepare_input!(String.t()) :: [{integer, integer}]
  def prepare_input!(filename) when is_binary(filename) do
    {:ok, content} = File.read(filename)

    content
    |> String.split("\n", trim: true)
    |> Enum.map(&Utils.split/1)
    |> Enum.with_index()
    |> Enum.flat_map(&Utils.coalesce/1)
  end
end
