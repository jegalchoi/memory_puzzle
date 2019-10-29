require 'byebug'
require 'pry'
require_relative "board"
require_relative "card"
require_relative "player"

input_prompt = '> '
puts "\nWelcome to Memory."
puts "\nFind all the pairs before you run out of attempts."
puts "\nEnter '1' for Human Player."
puts "Enter '2' for AI Player."
print input_prompt

player_type = gets.chomp.to_i
until (1..2).include?(player_type)
    puts "Please enter either '1' or '2'."
    print input_prompt
    player_type = gets.chomp.to_i
end

puts "\nLevels of difficulty: "
puts "1 - Easy (2 pairs)"
puts "2 - Medium (8 pairs)"
puts "3 - Hard (18 pairs)"
puts "Enter a number to set the level of difficulty:"
print input_prompt

difficulty = gets.chomp.to_i
until (1..3).include?(difficulty)
    puts "Please enter either '1', '2' or '3'."
    print input_prompt
    difficulty = gets.chomp.to_i
end
n = difficulty * 2

if player_type == 1
  player = HumanPlayer.new(n)
elsif player_type == 2
  player = ComputerPlayer.new(n)  
end

board = Board.new(n, player)
#debugger
until board.game_over?
  guess_1_pos = board.guess_pos
  board.store_revealed_card(guess_1_pos)
  guess_1_letter = board.guess_letter(guess_1_pos)

  guess_2_pos = board.guess_pos
  guess_2_pos = board.guess_pos while board.duplicate_pos?(guess_1_pos, guess_2_pos)
  board.clean_board
  board.store_revealed_card(guess_2_pos)
  guess_2_letter = board.guess_letter(guess_2_pos)

  board.render_board
  board.match?(guess_1_letter, guess_2_letter, guess_1_pos, guess_2_pos)
end