defmodule Utils do
  def guard_position(map) do
    y = map |> Enum.find_index(fn row -> row |> Enum.find(fn c -> c == :guard end) != nil end)
    x = map |> Enum.at(y) |> Enum.find_index(fn c -> c == :guard end)

    {x, y}
  end

  def place_at(map, {x, y} = position, value) do
    row = map |> Enum.at(y) |> List.replace_at(x, value)
    map |> List.replace_at(y, row)
  end

  def text_to_atom(text) do
    text |> Enum.map(&char_to_atom/1)
  end

  def char_to_atom(text) do
    case text do
      "#" -> :wall
      "." -> :unvis
      "^" -> :guard
    end
  end

  def next_direction(dir) do
    case dir do
      {0, -1} -> {1, 0}
      {1, 0} -> {0, 1}
      {0, 1} -> {-1, 0}
      {-1, 0} -> {0, -1}
    end
  end

  def outside_bounds(map, {x, y} = position) do
    if x < 0 or y < 0 do
      true
    else
      len_y = length(map)
      len_x = map |> Enum.at(0) |> length()
      x >= len_x or y >= len_y
    end
  end
end

defmodule Main do
  def guard_step(map, {x, y} = position, {dir_x, dir_y} = dir) do
    map = map |> Utils.place_at({x, y}, :visit)

    next_block_x = x + dir_x
    next_block_y = y + dir_y

    if Utils.outside_bounds(map, {next_block_x, next_block_y}) do
      map
    else
      next_block = map |> Enum.at(next_block_y) |> Enum.at(next_block_x)

      if(next_block == :wall) do
        dir = Utils.next_direction(dir)
        guard_step(map, position, dir)
      else
        guard_step(map, {next_block_x, next_block_y}, dir)
      end
    end
  end

  def main() do
    {:ok, content} = File.read("input.txt")

    map =
      content
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&Utils.text_to_atom/1)

    position = Utils.guard_position(map)

    map
    |> guard_step(position, {0, -1})
    |> IO.inspect(label: "map")
    |> Enum.map(fn x -> x |> Enum.count(fn x -> x == :visit end) end)
    |> IO.inspect()
    |> Enum.sum()
    |> IO.inspect()
  end
end

Main.main()
