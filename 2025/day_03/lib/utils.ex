defmodule Utils do
  @spec split_and_integerify(String.t()) :: [integer]
  def split_and_integerify(str) do
    String.split(str, "", trim: true) |> Enum.map(&String.to_integer/1)
  end

  @spec prepare_input!(String.t()) :: [[integer]]
  def prepare_input!(filename) when is_binary(filename) do
    {:ok, content} = File.read(filename)

    content
    |> String.split("\n", trim: true)
    |> Enum.map(&Utils.split_and_integerify/1)
  end
end
