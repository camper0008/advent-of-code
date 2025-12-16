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

  @spec dist(Circuit.t(), Junction.t()) :: number()
  def dist(%Circuit{} = circuit, %Junction{} = other) do
    circuit.parts |> Enum.map(fn part -> Junction.dist(part, other) end) |> Enum.min()
  end
end

defmodule Utils do
  @spec split_and_integerify(String.t()) :: Junction.t()
  def split_and_integerify(line) do
    [x, y, z] =
      String.split(line, ",", trim: true)
      |> Enum.map(&String.to_integer/1)

    %Junction{x: x, y: y, z: z}
  end

  @spec prepare_input!(String.t()) :: [{:up | :down, integer}]
  def prepare_input!(filename) when is_binary(filename) do
    {:ok, content} = File.read(filename)

    content
    |> String.split("\n", trim: true)
    |> Enum.map(&Utils.split_and_integerify/1)
  end
end
