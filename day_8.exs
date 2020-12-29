#! /usr/bin/elixir

defmodule Day8 do

  def read_boot_code() do
    instructions = File.read!("./resources/boot_code.txt")
    instructions
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn instr -> {instr, false} end)
  end

  def parse_instruction(instruction, {acc, row}) do
    [instr, op] = String.split(instruction, " ")
    case instr do
      "nop" -> {acc, row + 1}
      "acc" -> {acc + String.to_integer(op), row + 1}
      "jmp" -> {acc, row + String.to_integer(op)}
    end
  end

  def run_instructions(instructions) do
    run_instructions(instructions, {0, 0}, false)
  end
  def run_instructions(_flagged_instructions, {acc, _row}, true) do
    acc
  end
  def run_instructions(flagged_instructions, {acc, row}, _row_state) do
    IO.inspect(flagged_instructions)
    {inst, flag} = Enum.at(flagged_instructions, row)
    instructions = List.update_at(flagged_instructions, row, fn {inst, _flag} -> {inst, true} end)
    run_instructions(instructions, parse_instruction(inst, {acc, row}), flag)
  end

end

# with tests
ExUnit.start()
defmodule Day8.BootCodeTest do
  use ExUnit.Case
  import Day8

end
instructions = Day8.read_boot_code()
#First star!!
IO.puts(Day8.run_instructions(instructions))

#Second star!!

