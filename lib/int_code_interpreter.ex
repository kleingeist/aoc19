defmodule IntCodeInterpreter do
  @moduledoc false

  def run(program_input_list, noun, verb) do
    program_input = :array.from_list(program_input_list)
    program = set_input(program_input, noun, verb)
    _run(0, program, nil)
  end

  def run(program_input_list, input) do
    program_input = :array.from_list(program_input_list)
    _run(0, program_input, input)
  end

  defp set_input(program_input, noun, verb) do
    program_noun = :array.set(1, noun, program_input)
    :array.set(2, verb, program_noun)
  end

  defp _run(pos, program, input) do
    {opcode, modes} = parse_op(pos, program)
    case opcode do
      :undefined -> raise "end of program"
      99 -> :array.get(0, program)
      1 -> add(pos + 1, program, modes, input)
      2 -> mul(pos + 1, program, modes, input)
      3 -> read_input(pos + 1, program, modes, input)
      4 -> write_output(pos + 1, program, modes, input)
    end
  end

  defp parse_op(pos, program) do
    case :array.get(pos, program) do
      :undefined -> {:undefined, []}
      opvalue -> parse_op(opvalue)
    end
  end

  def parse_op(opvalue) do
    {op, modes} = IntUtils.to_list(opvalue) |> Enum.split(2)
    opcode = IntUtils.from_list(op)
    modes_stream = Stream.concat(modes, Stream.repeatedly(fn -> 0 end))
    {opcode, modes_stream}
  end

  defp add(pos, program, modes, input) do
    [x, y, out] = parse_params_write(pos, program, 3, modes)
    sum = x + y
    result = :array.set(out, sum, program)
    _run(pos + 3, result, input)
  end

  defp mul(pos, program, modes, input) do
    [x, y, out] = parse_params_write(pos, program, 3, modes)
    prod = x * y
    result = :array.set(out, prod, program)
    _run(pos + 3, result, input)
  end

  defp read_input(pos, program, modes, input) do
    [out] = parse_params_write(pos, program, 1, modes)
    result = :array.set(out, input, program)
    _run(pos + 1, result, input)
  end

  defp write_output(pos, program, modes, input) do
    [output] = parse_params(pos, program, 1, modes)
    :ok = IO.puts(output)
    _run(pos + 1, program, input)
  end

  defp parse_params_write(pos, program, num, modes) do
    {params_in, params_out} = Enum.map(pos..(pos + num - 1), &:array.get(&1, program)) |> Enum.split(-1)
    params = parse_params(program, params_in, modes) ++ params_out
    if Enum.any?(params, &(&1 == :undefined)) do
      raise "end of program"
    end
    params
  end

  defp parse_params(pos, program, num, modes) do
    params_in = Enum.map(pos..(pos + num - 1), &:array.get(&1, program))
    params = parse_params(program, params_in, modes)
    if Enum.any?(params, &(&1 == :undefined)) do
      IO.inspect({pos, program, num, modes, params_in, params})
      raise "end of program"
    end
    params
  end

  defp parse_params(program, params, modes) do
    Enum.zip(params, modes)
      |> Enum.map(fn {param, mode} -> parse_param(program, param, mode) end)
  end

  defp parse_param(_, :undefined, _) do
    :undefined
  end

  defp parse_param(program, param_pos, 0) do
    :array.get(param_pos, program)
  end

  defp parse_param(_, param, 1) do
    param
  end

end
