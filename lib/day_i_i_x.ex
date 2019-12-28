defmodule DayIIX do
  def task1(input_file) do
    layers = read_image_data(input_file) |> parse_layers(25, 6)

    layer =
      Enum.min_by(layers, fn layer ->
        List.flatten(layer) |> Enum.filter(&(&1 == 0)) |> Enum.count()
      end)

    {ones, twos} =
      List.flatten(layer)
      |> Enum.reduce({0, 0}, fn x, {ones, twos} ->
        case x do
          1 -> {ones + 1, twos}
          2 -> {ones, twos + 1}
          _ -> {ones, twos}
        end
      end)

    ones * twos
  end

  def task2(input_file) do
    read_image_data(input_file)
    |> parse_layers(25, 6)
    |> Enum.reduce(&merge_layers(&2, &1))
    |> print()
  end

  def merge_layers(top, bottom) do
    Enum.zip(top, bottom)
    |> Enum.map(&merge_rows/1)
  end

  def merge_rows({top, bottom}) do
    Enum.zip(top, bottom)
    |> Enum.map(
      &case &1 do
        {0, _} -> 0
        {1, _} -> 1
        {2, x} -> x
      end
    )
  end

  def print(image_layer) do
    Enum.each(image_layer, fn row ->
      print_row(row)
      IO.write("\n")
    end)
  end

  def print_row(row) do
    Enum.each(
      row,
      fn x ->
        case x do
          0 -> " "
          1 -> "#"
        end
        |> IO.write()
      end
    )
  end

  def read_image_data(input_file) do
    File.stream!(input_file, [], 1)
    |> Enum.filter(&(&1 != "\n"))
    |> Enum.map(&String.to_integer/1)
  end

  def parse_layers(image, width, height) do
    Enum.chunk_every(image, width)
    |> Enum.chunk_every(height)
  end
end
