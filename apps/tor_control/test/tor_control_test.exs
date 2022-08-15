defmodule TorControlTest do
  use ExUnit.Case
  doctest TorControl

  test "greets the world" do
    assert TorControl.hello() == :world
  end
end
