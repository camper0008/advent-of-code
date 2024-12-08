defmodule Main do
  def count_direction(table, x, y, dir_x, dir_y) do
    letters = ["X", "M", "A", "S"]

    0..3
    |> Enum.map(fn i ->
      letter = Enum.at(letters, i)

      pos_x =
        x + dir_x * i

      pos_y =
        y + dir_y * i

      if pos_x < 0 or pos_y < 0 do
        false
      else
        letter ==
          table
          |> Enum.at(pos_y, ["_", "_", "_", "_", "_"])
          |> Enum.at(pos_x, "_")
      end
    end)
    |> Enum.all?()
  end

  def count_xmas(table) do
    y_len = table |> length()
    x_len = table |> Enum.at(0) |> length()

    directions =
      [{-1, 1}, {0, 1}, {1, 1}] ++
        [{-1, 0}, {0, 0}, {1, 0}] ++
        [{-1, -1}, {0, -1}, {1, -1}]

    0..y_len
    |> Enum.flat_map(fn y ->
      0..x_len
      |> Enum.flat_map(fn x ->
        directions
        |> Enum.map(fn dir ->
          {dir_x, dir_y} = dir
          is_xmas = count_direction(table, x, y, dir_x, dir_y)
          is_xmas
        end)
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
