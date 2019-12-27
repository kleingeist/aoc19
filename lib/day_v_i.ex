defmodule DayVI do
  @moduledoc false

  def task1(input_file) do
    g = read_input_file(input_file) |> create_graph()
    checksum = orbit_checksum(g)
    :digraph.delete(g)
    checksum
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
    g = :digraph.new([:acyclic])
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
