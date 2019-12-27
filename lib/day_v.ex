defmodule DayV do
  @moduledoc false

  def task1(input_file) do
    input_list = IntUtils.read_intlist(input_file)
    IntCodeInterpreter.run(input_list, [1])
  end

  def task2(input_file) do
    input_list = IntUtils.read_intlist(input_file)
    IntCodeInterpreter.run(input_list, [5])
  end

end
