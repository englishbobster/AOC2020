defmodule Day4 do

  def load_passports() do
    passports = File.read!("./resources/passports.txt")
    passports
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn entry -> process_entry(entry) end)
  end

  def process_entry(entry) do
    entry
    |> String.replace("\n", " ")
    |> String.split(" ")
    |> Enum.map(fn val -> to_passport_field(val) end)
  end

  def to_passport_field(field_str) do
    [key, value] = field_str
                   |> String.split(":")
    {String.to_atom(key), value}
  end

  def valid_passport_fields?(passport_data) do
    passport_data
    |> Keyword.keys()
    |> Enum.sort()
    |> has_necessary_keys()
  end

  def has_necessary_keys(keys) do
    mandatory_keys = [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]
    optional_keys = [:cid]
    mandatory_keys
    |> Enum.reduce(true, fn mandatory_key, acc -> acc && Enum.member?(keys, mandatory_key)  end)
  end

  def count_passports_with_valid_fields() do
    load_passports()
    |> Enum.filter(fn passport -> valid_passport_fields?(passport) end)
    |> Enum.count()
  end

end

#First star!!
IO.puts(Day4.count_passports_with_valid_fields())

#Second star!!
