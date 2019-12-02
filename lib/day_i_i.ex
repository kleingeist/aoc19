defmodule DayII do
  @moduledoc false


  def intcode_interpreter(input_file) do
    input_list = File.read!(input_file)
                 |> String.split(",")
                 |> Enum.map(&String.trim/1)
                 |> Enum.map(&String.to_integer/1)
    input_array = :array.from_list(input_list)
    intcode_array = :array.set(2, 2, :array.set(1, 12, input_array))

    #    IO.inspect(:array.to_list(intcode_array))

    interprete(0, intcode_array)
  end

  def interprete(pos, array) do
    {op, x, y, out} = parse_op(pos, array)

    #    IO.inspect(pos)
    #    IO.inspect({op, x, y, out})
    #    IO.inspect(:array.to_list(array))

    case op do
      :undefined -> raise "end of array"
      99 -> :array.get(0, array)
      1 -> interprete(pos + 4, add(x, y, out, array))
      2 -> interprete(pos + 4, mul(x, y, out, array))
    end
  end

  def add(x, y, out, array) do
    sum = x + y
    :array.set(out, sum, array)
  end

  def mul(x, y, out, array) do
    prod = x * y
    :array.set(out, prod, array)
  end

  def parse_op(pos, array) do
    [opcode, posx, posy, out] = Enum.map(0..3, fn off -> :array.get(pos + off, array) end)
    op = [opcode, :array.get(posx, array), :array.get(posy, array), out]
    #    case Enum.any?(op, fn x -> x == :undefined end) do
    #      true -> raise "end of array"
    #      false -> List.to_tuple(op)
    #    end
    List.to_tuple(op)
  end
end
