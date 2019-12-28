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
    |> elem(0)
  end

  def task1b(input_file) do
    asteroids =
      read_asteroids(input_file)
      |> parse_asteroids()

    Enum.max_by(asteroids, fn station -> run_radar(station, asteroids) |> Enum.count() end)
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

  def task2(input_file) do
    asteroids =
      read_asteroids(input_file)
      |> parse_asteroids()

    # known form task1
    # x = {20, 19}
    station = task1(input_file)

    radar = run_radar(station, asteroids)
    vaporder = turnit(radar, [], [])
    IO.inspect(vaporder, limit: :infinity)
    # {Enum.at(vaporder, 199), Enum.at(vaporder, 200)}
    # vaporder
    Enum.at(vaporder, 199)
  end

  @spec run_radar(any, any) :: [any]
  def run_radar(station, asteroids) do
    Enum.reject(asteroids, &(&1 == station))
    |> Enum.sort_by(&get_distance({station, &1}))
    |> Enum.group_by(&get_slope({station, &1}))
    |> Enum.sort_by(fn {slope, _} -> get_angle(slope) end)
    |> Enum.map(fn {_, asteroid} -> asteroid end)
  end

  def turnit([[asteroid | line] | radar], next, acc) do
    turnit(radar, [line | next], [asteroid | acc])
  end

  def turnit([], [], acc) do
    Enum.reverse(acc)
  end

  def turnit([], next, acc) do
    IO.inspect(Enum.count(acc))
    radar = Enum.reverse(next) |> Enum.reject(&(&1 == []))
    turnit(radar, [], acc)
  end

  def slopes(list) do
    pairs(list)
    |> Enum.map(&get_slope/1)
  end

  def pairs([x | rest]) do
    Enum.map(rest, &{x, &1}) ++ pairs(rest)
  end

  def pairs([]), do: []

  def get_slope({{x1, y1}, {x2, y2}}) do
    s = {x2 - x1, y2 - y1}
    norm_slope(s)
  end

  def norm_slope({x, y}) do
    d = Math.gcd(x, y)
    {div(x, d), div(y, d)}
  end

  def get_distance({{x1, y1}, {x2, y2}}) do
    abs(x2 - x1) + abs(y2 - y1)
  end

  def get_angle({x, y}) do
    cond do
      x == 0 && y >= 0 -> 0
      x == 0 && y < 0 -> :math.pi()
      x >= 0 && y <= 0 -> :math.pi() / 2 - :math.atan(y / x)
      x >= 0 && y >= 0 -> :math.pi() + :math.atan(y / x)
      x <= 0 && y >= 0 -> :math.pi() + :math.atan(y / x)
      x <= 0 && y <= 0 -> :math.pi() * 2 + :math.atan(y / x)
    end
  end
end
