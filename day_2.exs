#! /usr/bin/elixir

defmodule Day2 do
  def read_passwords() do
    contents = File.read!("./resources/passwords.txt")
    contents
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line -> parse_line(line) end)
  end

  defp parse_line(line) do
    [range, char, pwd] = line
                         |> String.split(" ", trim: true)
    {parse_range(range), String.trim(char, ":"), pwd}
  end
  defp parse_range(str) do
    match_range = ~r/(?<min>\d*)\-(?<max>\d*)/
    %{"max" => max, "min" => min} = Regex.named_captures(match_range, str)
    {String.to_integer(min), String.to_integer(max)}
  end

  def policy_valid_in_range({{min, max}, ch, pwd}) do
    range = min..max
    freq = String.graphemes(pwd)
           |> Enum.filter(fn c -> c == ch end)
           |> Enum.count()
    freq in range
  end

  def policy_valid_single_position({{pos_1, pos_2}, ch, pwd}) do
  (String.at(pwd, pos_1 - 1) == ch) != (String.at(pwd, pos_2 - 1) == ch)
  end

  def check_passwords(policy_list, policy_function) do
    policy_list
    |> Enum.filter(fn policy -> policy_function.(policy) end)
    |> Enum.count()
  end

end

policy_list = Day2.read_passwords()

#First star!!
Day2.check_passwords(policy_list, &Day2.policy_valid_in_range/1)
|> IO.puts()

#Second star!!
Day2.check_passwords(policy_list, &Day2.policy_valid_single_position/1)
|> IO.puts()
