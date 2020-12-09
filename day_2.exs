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
    String.to_integer(min)..String.to_integer(max)
  end

  def check_valid({range, ch, pwd}) do
    freq = String.graphemes(pwd) |> Enum.filter(fn c -> c == ch end) |> Enum.count()
    freq in range
  end

  def check_passwords(policy_list) do
    policy_list
    |> Enum.filter(fn policy -> check_valid(policy) end)
    |> Enum.count()
  end

end

#First star!!
policy_list = Day2.read_passwords()
Day2.check_passwords(policy_list) |> IO.puts()

#Second star!!
