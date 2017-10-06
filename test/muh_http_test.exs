defmodule Muh.HTTPTest do
  use ExUnit.Case
  doctest Muh.HTTP

  test "greets the world" do
    assert Muh.HTTP.hello() == :world
  end
end
