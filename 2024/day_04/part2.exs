defmodule Main do
  def letter_at(table, x, y) do
    table
    |> Enum.at(y, [])
    |> Enum.at(x, "_")
  end

  def is_xmas(corner_00, corner_01, corner_10, corner_11) do
    corner_0_mas =
      (corner_00 == "M" and corner_01 == "S") or (corner_00 == "S" and corner_01 == "M")

    corner_1_mas =
      (corner_10 == "M" and corner_11 == "S") or (corner_10 == "S" and corner_11 == "M")

    corner_0_mas and corner_1_mas
  end

  def count_direction(table, x, y) do
    letter = table |> letter_at(x, y)

    if letter != "A" or x == 0 or y == 0 do
      false
    else
      corner_00 = letter_at(table, x - 1, y - 1)
      corner_01 = letter_at(table, x + 1, y + 1)

      corner_10 = letter_at(table, x - 1, y + 1)
      corner_11 = letter_at(table, x + 1, y - 1)

      xmas = is_xmas(corner_00, corner_01, corner_10, corner_11)
      if xmas, do: IO.puts("#{corner_00}.#{corner_11}\n.#{letter}.\n#{corner_10}.#{corner_01}\n")

      xmas
    end
  end

  def count_xmas(table) do
    y_len = table |> length()
    x_len = table |> Enum.at(0) |> length()

    0..y_len
    |> Enum.flat_map(fn y ->
      0..x_len
      |> Enum.map(fn x ->
        count_direction(table, x, y)
      end)
    end)
  end

  def main() do
    {:ok, content} = File.read("input.txt")

    strings =
      String.split(content, "\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    strings
    |> count_xmas()
    |> Enum.count(fn x -> x end)
    |> IO.puts()
  end
end

Main.main()
