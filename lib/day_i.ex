defmodule DayI do
  @moduledoc """
  Documentation for DayI.
  """

  def hello do
    :world
  end

  def required_fuel(input_path) do
    read_input_file(input_path)
    |> Enum.map(&DayI.calculate_fuel/1)
    |> Enum.sum
  end

  def calculate_fuel(mass) do
    fuel = div(mass, 3) - 2
    Enum.max([fuel, 0])
  end

  def read_input_file(path) do
    # TODO: error handling?
    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end
end
