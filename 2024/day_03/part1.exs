defmodule Main do
  def feed(content, state, statements) do
    if content == [] do
      statements
    else
      [head | tail] = content
      head_integer = Integer.parse(head)

      case state do
        :blank when head == "m" ->
          feed(tail, :m, statements)

        :m when head == "u" ->
          feed(tail, :mu, statements)

        :mu when head == "l" ->
          feed(tail, :mul, statements)

        :mul when head == "(" ->
          feed(tail, {:mul, "("}, statements)

        {:mul, "("} ->
          case head_integer do
            {int, _} -> feed(tail, {:mul, "(", int}, statements)
            :error -> feed(content, :blank, statements)
          end

        {:mul, "(", int} when head == "," ->
          feed(tail, {:mul, "(", int, ","}, statements)

        {:mul, "(", left, ",", right} when head == ")" ->
          statements = statements ++ [left * right]
          feed(tail, :blank, statements)

        {:mul, "(", left, ","} ->
          case head_integer do
            {int, _} -> feed(tail, {:mul, "(", left, ",", int}, statements)
            :error -> feed(content, :blank, statements)
          end

        {:mul, "(", old_int} ->
          case head_integer do
            {int, _} ->
              feed(tail, {:mul, "(", old_int * 10 + int}, statements)

            :error ->
              feed(content, :blank, statements)
          end

        {:mul, "(", left_int, ",", right_int} ->
          case head_integer do
            {int, _} ->
              feed(tail, {:mul, "(", left_int, ",", right_int * 10 + int}, statements)

            :error ->
              feed(content, :blank, statements)
          end

        _ ->
          feed(tail, :blank, statements)
      end
    end
  end

  def main() do
    {:ok, content} = File.read("input.txt")
    content = String.graphemes(content)
    IO.inspect(Enum.sum(feed(content, :blank, [])), charlists: :as_lists)
  end
end

Main.main()
