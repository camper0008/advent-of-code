defmodule Main do
  def split_and_integerify(value) do
    list = Enum.map(String.split(value, " ", trim: true), fn v -> 
      {int, _rest} = Integer.parse(v) 
      int
    end)

    list
  end

  def ascends(acc, v) do
    cond do
      v <= acc -> :unsafe
      v > acc ->
        diff = abs(acc - v)
        if diff >= 1 and diff <= 3, do: {:ascend, v}, else: :unsafe
      end
  end

  def descends(acc, v) do
    cond do
      v >= acc -> :unsafe
      v < acc ->
        diff = abs(acc - v)
        if diff >= 1 and diff <= 3, do: {:descend, v}, else: :unsafe
      end
  end

  def undecided(acc, v) do
    diff = abs(acc - v)
    cond do
      diff < 1 or diff > 3 -> :unsafe
      v > acc -> {:ascend, v}
      v < acc -> {:descend, v}
    end
  end

  def tolerant(report) do
    len = length(report)
    report = Enum.map(
      0..len-1, 
      fn x -> 
        Enum.take(report, x) 
          ++ 
        Enum.take(report, x-len+1) 
      end
    )
    report = Enum.map(report, fn r -> is_safe(r) end)
    unsafe_iterations = Enum.count(report, fn x -> x == :unsafe end)
    if unsafe_iterations > 1, do: :unsafe, else: :safe
  end

  def is_safe(report) do
    status = Enum.reduce(report, :initial, fn v, acc ->
      case acc do
        :unsafe -> :unsafe
        :initial -> {:undecided, v}
        {:undecided, acc} -> undecided(acc, v) 
        {:ascend, acc} -> ascends(acc, v)
        {:descend, acc} -> descends(acc, v)
    end
    end)
    if status == :unsafe, do: {:unsafe, report}, else: :safe
  end

  def main() do
    {:ok, content} = File.read("input.txt")
    content = String.split(content, "\n", trim: true);
    reports = Enum.map(content, fn st -> split_and_integerify(st) end)
    reports = Enum.count(reports, fn report -> is_safe(report) == :safe end)
    IO.puts(reports)
  end
end

Main.main()
