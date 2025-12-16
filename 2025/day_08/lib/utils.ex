defmodule Junction do
  @enforce_keys [:x, :y, :z]
  defstruct [:x, :y, :z]

  @type t :: %__MODULE__{
          x: integer(),
          y: integer(),
          z: integer()
        }

  @spec dist(Junction.t(), Junction.t()) :: float()
  def dist(%Junction{} = lhs, %Junction{} = rhs) do
    res =
      [{lhs.x - rhs.x}, {lhs.y - rhs.y}, {lhs.z - rhs.z}]
      |> Enum.map(fn {res} -> res ** 2 end)
      |> Enum.sum()

    res ** 0.5
  end
end

defmodule JunctionC do
  @enforce_keys [:junction, :conns]
  defstruct [:junction, :conns]

  @type t :: %__MODULE__{
          junction: Junction.t(),
          conns: [Junction.t()]
        }

  @spec connect(JunctionC.t(), JunctionC.t()) :: JunctionC.t()
  def connect(%JunctionC{} = lhs, %JunctionC{} = rhs) do
    %JunctionC{lhs | conns: [rhs.junction | lhs.conns]}
  end
end

defmodule Utils do
  def permutations([_]) do
    []
  end

  def permutations([item | tail]) do
    Enum.concat(tail |> Enum.map(fn other -> {item, other} end), permutations(tail))
  end

  @spec split_and_integerify(String.t()) :: JunctionC.t()
  def split_and_integerify(line) do
    [x, y, z] =
      String.split(line, ",", trim: true)
      |> Enum.map(&String.to_integer/1)

    %JunctionC{junction: %Junction{x: x, y: y, z: z}, conns: []}
  end

  @spec prepare_input!(String.t()) :: [JunctionC.t()]
  def prepare_input!(filename) when is_binary(filename) do
    {:ok, content} = File.read(filename)

    content
    |> String.split("\n", trim: true)
    |> Enum.map(&Utils.split_and_integerify/1)
  end
end
