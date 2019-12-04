defmodule DayII do
  @moduledoc false

  def program_alarm(input_file) do
    input_list = File.read!(input_file)
                 |> String.split(",")
                 |> Enum.map(&String.trim/1)
                 |> Enum.map(&String.to_integer/1)
    IntCodeInterpreter.run(input_list, 12, 2)
  end

  def task2(input_file) do
    input_list = File.read!(input_file)
                 |> String.split(",")
                 |> Enum.map(&String.trim/1)
                 |> Enum.map(&String.to_integer/1)

    expected_output = 19690720

    inputs = for noun <- 0..99, verb <- 0..99, do: {noun, verb}
    {noun, verb} = Enum.find(
      inputs,
      nil,
      fn {noun, verb} -> IntCodeInterpreter.run(input_list, noun, verb) == expected_output end
    )
    100 * noun + verb
  end
end
