defmodule IntCodeInterpreter do
  @moduledoc false

  def run(program_input_list, noun, verb) do
    program_input = :array.from_list(program_input_list)
    program = set_input(program_input, noun, verb)
    run(0, program)
  end

  defp set_input(program_input, noun, verb) do
    program_noun = :array.set(1, noun, program_input)
    :array.set(2, verb, program_noun)
  end

  defp run(pos, program) do
    opcode = :array.get(pos, program)
    case opcode do
      :undefined -> raise "end of program"
      99 -> :array.get(0, program)
      1 -> add(pos + 1, program)
      2 -> mul(pos + 1, program)
    end
  end

  defp add(pos, program) do
    [x, y, out] = parse_op3(pos, program)
    sum = x + y
    result = :array.set(out, sum, program)
    run(pos + 3, result)
  end

  defp mul(pos, program) do
    [x, y, out] = parse_op3(pos, program)
    prod = x * y
    result = :array.set(out, prod, program)
    run(pos + 3, result)
  end

  defp parse_op3(pos, program) do
    [posx, posy, out] = Enum.map(0..2, &:array.get(pos + &1, program))
    op = [:array.get(posx, program), :array.get(posy, program), out]
    case Enum.any?(op, &(&1 == :undefined)) do
      true -> raise "end of program"
      false -> op
    end
  end

end
