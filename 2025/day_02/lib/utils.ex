defmodule Utils do
  @spec split_and_integerify(String.t()) :: {integer, integer}
  def split_and_integerify(value) do
    [left, right] = String.split(value, ["-", "\n"], trim: true)

    {String.to_integer(left), String.to_integer(right)}
  end

  @spec prepare_input!(String.t()) :: [{integer, integer}]
  def prepare_input!(filename) when is_binary(filename) do
    {:ok, content} = File.read(filename)

    content
    |> String.split(",", trim: true)
    |> Enum.map(&Utils.split_and_integerify/1)
  end
end
