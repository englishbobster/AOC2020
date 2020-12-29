#! /usr/bin/elixir

defmodule Day8 do

  def read_boot_code() do
    instructions = File.read!("./resources/boot_code.txt")
    instructions
    |> String.trim()
    |> String.split("\n")
  end

end

# with tests
ExUnit.start()
defmodule Day8.BootCodeTest do
  use ExUnit.Case
  import Day8

end

#First star!!


#Second star!!

