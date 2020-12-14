defmodule Day5 do

  def load_boarding_passes() do
    passes = File.read!("./resources/boarding_passes.txt")
    passes
    |> String.trim()
    |> String.split("\n")
  end

end

#First star!!

#Second star!!
