defmodule UtilsPart2 do
  @type operation() :: :mul | :plus

  defp build_struct(lines, [], acc) do
    acc |> Enum.reverse()
  end

  defp build_struct(lines, [length | tail], acc) do
    numbers =
      lines
      |> Enum.map(&(String.codepoints(&1) |> Enum.take(length) |> Enum.join()))

    lines =
      lines
      |> Enum.map(&(String.codepoints(&1) |> Enum.drop(length + 1) |> Enum.join()))

    build_struct(lines, tail, [numbers | acc])
  end

  def rotate(input) do
    row_length = input |> Enum.map(&Enum.count/1) |> Enum.max()

    0..(row_length - 1)
    |> Enum.map(fn idx -> Enum.map(input, fn row -> Enum.fetch!(row, idx) end) end)
  end

  @spec prepare_input!(String.t()) :: [{[integer], operation()}]
  def prepare_input!(filename) when is_binary(filename) do
    {:ok, content} = File.read(filename)

    numbers =
      content
      |> String.split("\n", trim: true)
      |> Enum.take_while(fn x ->
        not Enum.any?(String.split(x, " ", trim: true), fn x -> x in ["+", "*"] end)
      end)

    number_lengths =
      numbers
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> rotate()
      |> Enum.map(&(Enum.map(&1, fn x -> String.length(x) end) |> Enum.max()))

    numbers =
      build_struct(numbers, number_lengths, [])
      |> Enum.map(fn x -> Enum.map(x, fn x -> String.split(x, "", trim: true) end) end)
      |> Enum.map(&rotate/1)
      |> Enum.map(fn x ->
        Enum.map(x, fn x -> Enum.join(x) |> String.trim() |> String.to_integer() end)
      end)

    operations =
      content
      |> String.split("\n", trim: true)
      |> Enum.drop_while(fn x ->
        not Enum.any?(String.split(x, " ", trim: true), fn x -> x in ["+", "*"] end)
      end)
      |> Enum.flat_map(&String.split(&1, " ", trim: true))
      |> Enum.map(fn x ->
        case x do
          "+" -> :plus
          "*" -> :mul
        end
      end)

    Enum.zip(numbers, operations)
  end
end
