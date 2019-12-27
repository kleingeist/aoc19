defmodule DayVII do
  @moduledoc false

  def task1(input_file) do
    program_list = IntUtils.read_intlist(input_file)
    # greedy_max(program_list)
    full_max(program_list)
  end

  def task1greedy(input_file) do
    program_list = IntUtils.read_intlist(input_file)
    greedy_max(program_list)
  end

  def greedy_max(program_list) do
    greedy_max(program_list, [0, 1, 2, 3, 4], [], 0)
  end

  defp greedy_max(_, [], configuration, signal) do
    {Enum.reverse(configuration), signal}
  end

  defp greedy_max(program_list, phase_settings, configuration, signal) do
    {signal, phase} =
      Enum.map(
        phase_settings,
        fn phase_setting ->
          {_, [boosted]} = IntCodeInterpreter.run(program_list, [phase_setting, signal])
          {boosted, phase_setting}
        end
      )
      |> Enum.max_by(fn {signal, _} -> signal end)

    greedy_max(program_list, phase_settings -- [phase], [phase | configuration], signal)
  end

  defp full_max(program_list) do
    Permutations.of(Enum.to_list(0..4))
    |> Enum.map(fn phases ->
      {phases,
       Enum.reduce(phases, 0, fn phase, signal ->
         {_, [boosted]} = IntCodeInterpreter.run(program_list, [phase, signal])
         boosted
       end)}
    end)
    |> Enum.max_by(fn {_, signal} -> signal end )
  end
end
