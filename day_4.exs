defmodule Day4 do

  def load_passports() do
    passports = File.read!("./resources/passports.txt")
    passports
    |> String.trim()
    |> String.split("\n\n")
  end

end

#First star!!

#Second star!!
