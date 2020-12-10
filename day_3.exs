defmodule Day3 do
  def read_passwords() do
    contents = File.read!("./resources/passwords.txt")
    contents
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line -> parse_line(line) end)
  end



end

policy_list = Day2.read_passwords()

#First star!!

#Second star!!
