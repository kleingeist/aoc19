defmodule DayI do
  @moduledoc """
  Documentation for DayI.
  """

  def hello do
    :world
  end

  def required_fuel(input_path) do
    read_input_file(input_path)
    |> Enum.map(&DayI.calculate_fuel_for_mass/1)
    |> Enum.sum
  end

  def required_fuel_recursive(input_path) do
    read_input_file(input_path)
    |> Enum.map(&DayI.calculate_fuel_for_module/1)
    |> Enum.sum
  end

  def calculate_fuel_for_mass(mass) do
    div(mass, 3) - 2
  end

  def calculate_fuel_for_module(mass) do
    fuel = calculate_fuel_for_mass(mass)
    calculate_fuel_recursive(fuel, 0)
  end

  def calculate_fuel_recursive(fuel, total_fuel) when fuel <= 0 do
    total_fuel
  end


  def calculate_fuel_recursive(fuel, total_fuel) do
    calculate_fuel_recursive(calculate_fuel_for_mass(fuel), total_fuel + fuel)
  end

  def read_input_file(path) do
    # TODO: error handling?
    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end
end
