defmodule Utils do
  @spec split_and_integerify(String.t()) :: {:up | :down, integer}
  def split_and_integerify(value) do
    direction =
      case String.slice(value, 0..0) do
        "R" -> :up
        "L" -> :down
      end

    {rotations, _rest} = Integer.parse(String.slice(value, 1..String.length(value)))
    {direction, rotations}
  end

  @spec prepare_input!(String.t()) :: [{:up | :down, integer}]
  def prepare_input!(filename) when is_binary(filename) do
    {:ok, content} = File.read(filename)

    content
    |> String.split("\n", trim: true)
    |> Enum.map(&Utils.split_and_integerify/1)
  end
end
