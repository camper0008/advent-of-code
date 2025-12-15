defmodule UtilsPart1 do
  @type operation() :: :mul | :plus

  @spec split_and_integerify(String.t()) :: [integer()]
  def split_and_integerify(value) do
    value |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
  end

  @spec prepare_input!(String.t()) :: [{[integer], operation()}]
  def prepare_input!(filename) when is_binary(filename) do
    {:ok, content} = File.read(filename)

    numbers =
      content
      |> String.split("\n", trim: true)
      |> Enum.take_while(fn x ->
        not Enum.any?(String.split(x, "", trim: true), fn x -> x in ["+", "*"] end)
      end)
      |> Enum.map(&split_and_integerify/1)

    operations =
      content
      |> String.split("\n", trim: true)
      |> Enum.drop_while(fn x ->
        not Enum.any?(String.split(x, "", trim: true), fn x -> x in ["+", "*"] end)
      end)
      |> Enum.flat_map(fn x ->
        String.split(x, " ", trim: true)
        |> Enum.map(fn x ->
          case x do
            "*" -> :mul
            "+" -> :plus
          end
        end)
      end)

    for idx <- 0..(length(operations) - 1),
        do: {
          numbers
          |> Enum.map(fn row -> Enum.fetch!(row, idx) end),
          Enum.fetch!(operations, idx)
        }
  end
end
