defmodule DayX do
  def read_asteroids(input_file) do
    File.stream!(input_file)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def parse_asteroids(map) do
    Enum.with_index(map)
    |> Enum.flat_map(fn {row, y} ->
      Enum.with_index(row)
      |> Enum.flat_map(
        &case &1 do
          {"#", x} -> [{x, y}]
          _ -> []
        end
      )
    end)
  end

  def task1(input_file) do
    read_asteroids(input_file)
    |> parse_asteroids()
    |> sights()
    |> Enum.max_by(&elem(&1, 1))
  end

  def sights(asteroids) do
    Enum.map(asteroids, fn x ->
      {x,
       Enum.filter(asteroids, &(&1 != x))
       |> Enum.map(&get_slope({x, &1}))
       |> Enum.uniq()
       |> Enum.count()}
    end)
  end

  # def slopes(list) do
  #   pairs(list)
  #   |> Enum.map(&get_slope/1)
  #   |> Enum.uniq()
  # end

  # def pairs([x | rest]) do
  #   Enum.map(rest, &{x, &1}) ++ pairs(rest)
  # end

  # def pairs([]), do: []

  def get_slope({{x1, y1}, {x2, y2}}) do
    s = {x2 - x1, y2 - y1}
    norm_slope(s)
  end

  def norm_slope({x, y}) do
    d = gcd(x, y)
    {div(x, d), div(y, d)}
  end

  def gcd(a, 0), do: abs(a)
  def gcd(a, b), do: gcd(b, rem(a, b))
end
