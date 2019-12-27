defmodule IntCodeInterpreter do
  @moduledoc false

  def run(program_input_list, noun, verb) do
    program_input = :array.from_list(program_input_list)
    program = set_input(program_input, noun, verb)
    _run(0, program, {[], []})
  end

  defp set_input(program_input, noun, verb) do
    program_noun = :array.set(1, noun, program_input)
    :array.set(2, verb, program_noun)
  end

  def run(program_input_list, input) do
    program_input = :array.from_list(program_input_list)
    _run(0, program_input, {input, []})
  end

  defp _run(pos, program, io) do
    {opcode, _} = parse_op(pos, program)
    case opcode do
      :undefined -> raise "end of program"
      99 -> return(program, io)
      1 -> add(pos, program, io)
      2 -> mul(pos, program, io)
      3 -> read_input(pos, program, io)
      4 -> write_output(pos, program, io)
      5 -> jump_if(true, pos, program, io)
      6 -> jump_if(false, pos, program, io)
      7 -> cmp(&</2, pos, program, io)
      8 -> cmp(&==/2, pos, program, io)
    end
  end

  defp return(program, {_, out}) do
    {:array.get(0, program), Enum.reverse(out)}
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

  defp add(pos, program, io) do
    [x, y, out] = parse_params_out(pos, program, 3)
    sum = x + y
    result = :array.set(out, sum, program)
    _run(pos + 4, result, io)
  end

  defp mul(pos, program, io) do
    [x, y, out] = parse_params_out(pos, program, 3)
    prod = x * y
    result = :array.set(out, prod, program)
    _run(pos + 4, result, io)
  end

  defp read_input(pos, program, io) do
    [out] = parse_params_out(pos, program, 1)
    {[input_value | input], output} = io
    # IO.inspect({pos, out, input_value})
    result = :array.set(out, input_value, program)
    _run(pos + 2, result, {input, output})
  end

  defp write_output(pos, program, io) do
    [output_value] = parse_params(pos, program, 1)
    {input, output} = io
    _run(pos + 2, program, {input, [output_value | output]})
  end

  defp jump_if(condition, pos, program, io) do
    [val, pos_jump] = parse_params(pos, program, 2)
    is_truthy = (val != 0)
    cond do
      is_truthy == condition -> _run(pos_jump, program, io)
      true -> _run(pos + 3, program, io)
    end
  end

  defp cmp(comparator, pos, program, io) do
    [x, y, out] = parse_params_out(pos, program, 3)
    result = case comparator.(x, y) do
      true -> :array.set(out, 1, program)
      false -> :array.set(out, 0, program)
    end
    _run(pos + 4, result, io)
  end

  defp parse_params_out(pos, program, num) do
    {_, modes} = parse_op(pos, program)
    modes = Enum.take(modes, num - 1) ++ [1]
    _parse_params(pos + 1, program, num, modes)
  end

  def parse_params(pos, program, num) do
    {_, modes} = parse_op(pos, program)
    _parse_params(pos + 1, program, num, modes)
  end

  defp _parse_params(param_pos, program, num, modes) do
    params_in = Enum.map(param_pos..(param_pos + num - 1), &:array.get(&1, program))
    params =
      Enum.zip(params_in, modes)
        |> Enum.map(fn {param, mode} -> parse_param(program, param, mode) end)

    if Enum.any?(params, &(&1 == :undefined)) do
      IO.inspect({param_pos, program, num, modes, params_in, params})
      raise "end of program"
    end
    params
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
