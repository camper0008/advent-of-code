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

defmodule Circuit do
  @enforce_keys [:parts]
  defstruct [:parts]

  @type t :: %__MODULE__{
          parts: [Junction.t()]
        }

  @spec dist(Circuit.t(), Circuit.t()) :: number()
  def dist(%Circuit{} = circuit, %Circuit{} = other) do
    perms =
      for x <- circuit.parts do
        for y <- other.parts do
          {x, y}
        end
      end

    perms = perms |> Enum.flat_map(& &1)

    perms
    |> Enum.map(fn {lhs, rhs} -> Junction.dist(lhs, rhs) end)
    |> Enum.min()
  end

  @spec merge(Circuit.t(), Circuit.t()) :: Circuit.t()
  def merge(%Circuit{} = lhs, %Circuit{} = rhs) do
    %Circuit{parts: lhs.parts ++ rhs.parts}
  end
end

defmodule Utils do
  def permutations([_]) do
    []
  end

  def permutations([item | tail]) do
    Enum.concat(tail |> Enum.map(fn other -> {item, other} end), permutations(tail))
  end

  @spec split_and_integerify(String.t()) :: Circuit.t()
  def split_and_integerify(line) do
    [x, y, z] =
      String.split(line, ",", trim: true)
      |> Enum.map(&String.to_integer/1)

    %Circuit{parts: [%Junction{x: x, y: y, z: z}]}
  end

  @spec prepare_input!(String.t()) :: [Circuit.t()]
  def prepare_input!(filename) when is_binary(filename) do
    {:ok, content} = File.read(filename)

    content
    |> String.split("\n", trim: true)
    |> Enum.map(&Utils.split_and_integerify/1)
  end
end
