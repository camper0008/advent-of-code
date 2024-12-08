defmodule Main do
  def feed(content, state, statements, enabled) do
    if content == [] do
      statements
    else
      [head | tail] = content
      head_integer = Integer.parse(head)

      case state do
        :blank when head == "m" ->
          feed(tail, :m, statements, enabled)

        :blank when head == "d" ->
          feed(tail, :d, statements, enabled)

        :d when head == "o" ->
          feed(tail, :do, statements, true)

        :do when head == "n" ->
          feed(tail, :don, statements, enabled)

        :don when head == "'" ->
          feed(tail, :donA, statements, enabled)

        :donA when head == "t" ->
          feed(tail, :blank, statements, false)

        :m when head == "u" ->
          feed(tail, :mu, statements, enabled)

        :mu when head == "l" ->
          feed(tail, :mul, statements, enabled)

        :mul when head == "(" ->
          feed(tail, {:mul, "("}, statements, enabled)

        {:mul, "("} ->
          case head_integer do
            {int, _} -> feed(tail, {:mul, "(", int}, statements, enabled)
            :error -> feed(content, :blank, statements, enabled)
          end

        {:mul, "(", int} when head == "," ->
          feed(tail, {:mul, "(", int, ","}, statements, enabled)

        {:mul, "(", left, ",", right} when head == ")" ->
          statements = if enabled, do: statements ++ [left * right], else: statements
          feed(tail, :blank, statements, enabled)

        {:mul, "(", left, ","} ->
          case head_integer do
            {int, _} -> feed(tail, {:mul, "(", left, ",", int}, statements, enabled)
            :error -> feed(content, :blank, statements, enabled)
          end

        {:mul, "(", old_int} ->
          case head_integer do
            {int, _} ->
              feed(tail, {:mul, "(", old_int * 10 + int}, statements, enabled)

            :error ->
              feed(content, :blank, statements, enabled)
          end

        {:mul, "(", left_int, ",", right_int} ->
          case head_integer do
            {int, _} ->
              feed(tail, {:mul, "(", left_int, ",", right_int * 10 + int}, statements, enabled)

            :error ->
              feed(content, :blank, statements, enabled)
          end

        _ ->
          feed(tail, :blank, statements, enabled)
      end
    end
  end

  def main() do
    {:ok, content} = File.read("input.txt")
    content = String.graphemes(content)
    IO.inspect(Enum.sum(feed(content, :blank, [], true)), charlists: :as_lists)
  end
end

Main.main()
