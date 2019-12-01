defmodule DayITest do
  use ExUnit.Case
  doctest DayI

  test "greets the world" do
    assert DayI.hello() == :world
  end
end
