defmodule DayIV do
  @moduledoc false

  @input {264793, 803935}

  def possible_passes2() do
    possible_passes()
    |> Enum.map(&to_int_list/1)
    |> Enum.filter  (&is_pass2/1)
  end

  defp is_pass2([head | int_list]) do
    List.foldl(
      int_list,
      [{head, 1}],
      fn current, [{prev, cnt} | acc] -> cond do
                                           current == prev -> [{prev, cnt + 1} | acc]
                                           true -> [{current, 1} | [{prev, cnt} | acc]]
                                         end
      end
    )
    |> Enum.any?(fn {_, cnt} -> cnt == 2 end)
  end

  def possible_passes() do
    {min, max} = @input
    first = next_possible(min)
    all_possible_passes(first, max, [])
  end

  defp all_possible_passes(_, max, [current | acc]) when current > max do
    acc
  end

  defp all_possible_passes(next, max, acc) do
    current = next_possible(next)
    all_possible_passes(current + 1, max, [current | acc])
  end

  def to_int_list(value) do
    to_string(value)
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
  end

  defp to_int(int_list) do
    _to_int(Enum.reverse(int_list))
  end

  defp _to_int([head | tail]) do
    head + 10 * _to_int(tail)
  end

  defp _to_int([]) do
    0
  end

  def next_possible(value) do
    int_list = to_int_list(value)
    next = _next_possible([], int_list)
    next_int = _to_int(next)

    case has_doubles(next) do
      true -> next_int
      false -> next_possible(next_int + 1)
    end
  end

  defp _next_possible([], [head | tail]) do
    _next_possible([head], tail)
  end

  defp _next_possible([last | front], [head | tail]) when last > head do
    # add the last element as every remaining elem in the list
    next = List.foldl([head | tail], [last | front], fn _, acc -> [last | acc] end)
    _next_possible(next, [])
  end

  defp _next_possible([last | front], [head | tail]) when last <= head do
    _next_possible([head | [last | front]], tail)
  end

  defp _next_possible(next, []) do
    #    Enum.reverse(next)
    next
  end

  defp has_doubles([a | [a | _]]) do
    true
  end

  defp has_doubles([head | tail]) do
    has_doubles(tail)
  end

  defp has_doubles([]) do
    false
  end

end
