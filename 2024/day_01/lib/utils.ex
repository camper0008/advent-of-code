defmodule Utils do
  @spec split_and_integerify(String.t()) :: {integer, integer}
  def split_and_integerify(value) do
    [left, right] = String.split(value, " ", trim: true)
    {left, _rest} = Integer.parse(left)
    {right, _rest} = Integer.parse(right)
    {left, right}
  end

  @spec prepare_input!(String.t()) :: {[integer], [integer]}
  def prepare_input!(filename) when is_binary(filename) do
    {:ok, content} = File.read(filename)

    content
    |> String.split("\n", trim: true)
    |> Enum.map(fn st -> Utils.split_and_integerify(st) end)
    |> Enum.unzip()
  end
end
