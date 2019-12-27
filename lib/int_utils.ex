defmodule IntUtils do
  @moduledoc false

  def to_list(val) when val > 0 do
    [rem(val, 10) | to_list(div(val, 10))]
  end

  def to_list(val) when val <= 0 do
    []
  end

  def from_list(val) do
    Enum.with_index(val)
    |> Enum.map(fn {v, i} -> v * trunc(:math.pow(10, i)) end)
    |> Enum.sum
  end

end
