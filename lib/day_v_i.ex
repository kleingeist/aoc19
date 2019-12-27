defmodule DayVI do
  @moduledoc false

  def task1(input_file) do
    g = read_input_file(input_file) |> create_graph()
    checksum = orbit_checksum(g)
    :digraph.delete(g)
    checksum
  end

  def task2b(input_file) do
    g = read_input_file(input_file) |> create_graph()
    {root, _} = :digraph.vertex(g, "COM")
    {you, _} = :digraph.vertex(g, "YOU")
    {san, _} = :digraph.vertex(g, "SAN")

    path_you = :digraph.get_path(g, root, you)
    path_san = :digraph.get_path(g, root, san)

    :digraph.delete(g)

    prefix = common_prefix(path_you, path_san)
    prefix_length = Enum.count(prefix)
    you_from_common = Enum.count(path_you) - prefix_length - 1
    san_from_common = Enum.count(path_san) - prefix_length - 1
    you_from_common + san_from_common
  end

  def common_prefix(a, b) do
    Enum.zip(a, b)
    |> Enum.take_while(fn {a, b} -> a == b end)
  end

  def task2(input_file) do
    g = read_input_file(input_file) |> create_graph()
    {root, _} = :digraph.vertex(g, "COM")
    {you, _} = :digraph.vertex(g, "YOU")
    {san, _} = :digraph.vertex(g, "SAN")

    :ok = add_back_edges(g, you, root)
    path = :digraph.get_short_path(g, you, san)
    :digraph.delete(g)
    Enum.count(path) - 2 - 1
  end

  def add_back_edges(g, current, root) do
    [parent] = :digraph.in_neighbours(g, current)
    add_back_edges(g, parent, root, current)
  end

  def add_back_edges(g, root, root, child) do
    :digraph.add_edge(g, child, root)
    :ok
  end

  def add_back_edges(g, current, root, child) do
    [parent] = :digraph.in_neighbours(g, current)
    :digraph.add_edge(g, child, current)
    add_back_edges(g, parent, root, current)
  end

  def orbit_checksum(g) do
    {root, _} = :digraph.vertex(g, "COM")
    orbit_checksum(g, [root], 0)
  end

  defp orbit_checksum(g, [v | vertices], depth) do
    children = :digraph.out_neighbours(g, v)
    depth + orbit_checksum(g, children, depth + 1) + orbit_checksum(g, vertices, depth)
  end

  defp orbit_checksum(_, [], _) do
    0
  end

  def create_graph(input_list) do
    # g = :digraph.new([:acyclic])
    g = :digraph.new()

    for [vv1, vv2] <- input_list do
      v1 = :digraph.add_vertex(g, vv1)
      v2 = :digraph.add_vertex(g, vv2)
      :digraph.add_edge(g, v1, v2)
    end

    g
  end

  def read_input_file(path) do
    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ")"))
  end
end
