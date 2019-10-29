require 'byebug'
require 'pry'

class Player
  attr_accessor :known_cards, :paired_cards, :matched_cards, :attempts_left, :board_length

  def initialize(n)
    @board_length = n
    @known_cards = {}
    @paired_cards = []
    @matched_cards = []
    @attempts_left = n * n
  end

  def prompt
    puts "\nPlease enter the position of the card you would like to flip (e.g., '2,3')."
    self.input
  end
end

class HumanPlayer < Player
  def input
    pos = gets.chomp 
    pos = gets.chomp until self.valid_input?(pos)
    pos.split(",").map { |n| n.to_i }
  end

  def valid_input?(input)
    if !input.include?(",") || /[a-z]/ =~ input
      puts "\nThat is an invalid entry.  Please try again."
      return false
    end
    true
  end
end

class ComputerPlayer < Player
  def input
    if @guess_number == 0
      pos = self.random_pos
    elsif @paired_cards.empty?
      pos = self.random_pos
      pos = self.random_pos while @known_cards.values.include?(pos) || @matched_cards.include?(pos) || @paired_cards.include?(pos)
      pos
    else
      @paired_cards.pop
    end
  end

  def random_pos
    range = (0...@board_length)
    [rand(range), rand(range)]
  end
end