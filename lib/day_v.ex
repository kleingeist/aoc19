defmodule DayV do
  @moduledoc false

  def task1(input_file) do
    input_list = File.read!(input_file)
                 |> String.split(",")
                 |> Enum.map(&String.trim/1)
                 |> Enum.map(&String.to_integer/1)
    IntCodeInterpreter.run(input_list, 1)
  end

end
