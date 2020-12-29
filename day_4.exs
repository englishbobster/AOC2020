#! /usr/bin/elixir

defmodule Day4 do
  #  @optional_keys [:cid]
  @allowed_eye_colours [:amb, :blu, :brn, :gry, :grn, :hzl, :oth]

  def load_passports() do
    passports = File.read!("./resources/passports.txt")
    passports
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn entry -> process_entry(entry) end)
  end

  def get_mandatory_keys do
    [
      {:byr, &validate_byr/1},
      {:iyr, &validate_iyr/1},
      {:eyr, &validate_eyr/1},
      {:hgt, &validate_height/1},
      {:hcl, &validate_hair_colour/1},
      {:ecl, &validate_eye_colour/1},
      {:pid, &validate_passport_id/1}
    ]
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
    get_mandatory_keys()
    |> Keyword.keys
    |> Enum.reduce(true, fn mandatory_key, acc -> acc && Enum.member?(keys, mandatory_key)  end)
  end

  def find_passports_with_correct_fields() do
    load_passports()
    |> Enum.filter(fn passport -> valid_passport_fields?(passport) end)
  end

  def validate_year_between(year_str, least, most) do
    year = String.to_integer(year_str)
    Integer.digits(year)
    |> length() == 4 && (year >= least) && (year <= most)
  end
  def validate_byr(year_str) do
    validate_year_between(year_str, 1920, 2002)
  end
  def validate_iyr(year_str) do
    validate_year_between(year_str, 2010, 2020)
  end
  def validate_eyr(year_str) do
    validate_year_between(year_str, 2020, 2030)
  end

  def validate_height(height_str) do
    height_regex = ~r/(?<value>\d+)(?<unit>cm|in)/
    case Regex.named_captures(height_regex, height_str) do
      %{"value" => value, "unit" => unit} -> validate_height_value(value, unit)
      _ -> false
    end
  end

  def validate_height_value(value_str, unit) do
    value = String.to_integer(value_str)
    case unit do
      "in" -> value >= 59 && value <= 76
      "cm" -> value >= 150 && value <= 193
      _ -> false
    end
  end

  def validate_hair_colour(colour) do
    hair_regex = ~r/^#[0-9a-fA-F]{6}$/
    Regex.match?(hair_regex, colour)
  end

  def validate_eye_colour(colour) do
    String.to_atom(colour) in @allowed_eye_colours
  end

  def validate_passport_id(id) do
    pid_regex = ~r/^[0-9]{9}$/
    Regex.match?(pid_regex, id)
  end

  def count_passports_with_valid_fields() do
    find_passports_with_correct_fields()
    |> Enum.count()
  end

  def count_passports_with_valid_fields_and_values() do
    find_passports_with_correct_fields()
    |> Enum.map(fn passport -> validate_passport_values(passport) end)
    |> Enum.count(fn valid -> valid == true end)
  end

  def validate_passport_values(passport) do
    get_mandatory_keys()
    |> Enum.map(
         fn {key, func} ->
           val = Keyword.get(passport, key)
           result = func.(val)
           #IO.puts("Try validate #{key} result: #{result} for val: #{val}")
           result
         end
       )
    |> Enum.reduce(true, fn valid, acc -> acc && valid end)
  end

end

# with tests
ExUnit.start()
defmodule Day4.PassportTest do
  import Day4
  use ExUnit.Case

  test "count valid passports" do
    pp1 = "eyr:1972 cid:100 hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926"
    pp2 = "iyr:2019 hcl:#602927 eyr:1967 hgt:170cm ecl:grn pid:012533040 byr:1946"
    pp3 = "hcl:dab227 iyr:2012 ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277"
    pp4 = "hgt:59cm ecl:zzz eyr:2038 hcl:74454a iyr:2023 pid:3556412378 byr:2007"
    pp5 = "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f"
    pp6 = "eyr:2029 ecl:blu cid:129 byr:1989 iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm"
    pp7 = "hcl:#888785 hgt:164cm byr:2001 iyr:2015 cid:88 pid:545766238 ecl:hzl eyr:2022"
    pp8 = "iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"
    result = [pp1, pp2, pp3, pp4, pp5, pp6, pp7, pp8]
             |> Enum.map(fn entry -> process_entry(entry) end)
             |> Enum.filter(fn passport -> valid_passport_fields?(passport) end)
             |> Enum.map(fn passport -> validate_passport_values(passport) end)
             |> Enum.count(fn valid -> valid == true end)
    assert result == 4

  end
end

#First star!!
IO.puts(Day4.count_passports_with_valid_fields())

#Second star!!
IO.puts(Day4.count_passports_with_valid_fields_and_values())
