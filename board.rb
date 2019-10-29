require 'byebug'
require 'pry'
require_relative 'card'
require_relative 'player'

#puts 'START'

class Board
  attr_accessor :player
  attr_reader :grid, :pairs, :attempts

  def initialize(n=6, player)
    @player = player
    @size = n * n
    shuffled_letters = self.generate_letters(@size)
    @grid = self.populate_board(n, shuffled_letters)
    @attempts = 0
    @pairs = 0
  end
  
  def prompt
    self.clean_board(1)
    self.render_board
    input = @player.prompt
    return input if valid_pos?(input) && !revealed_pos?(input)
    self.prompt
  end

  def guess_pos
    pos_guess = self.prompt
  end

  def guess_letter(pos)
    letter_guess = self[pos].reveal
    self.attempted
    letter_guess
  end

  def attempted
    @player.attempts_left -= 1
  end

  def store_revealed_card(pos)
    letter = self[pos].face_up_value
    pos_2 = @player.known_cards[letter]
    if @player.known_cards.has_key?(letter) && pos != pos_2
      @player.paired_cards << pos
      @player.paired_cards << pos_2
      @player.known_cards.delete(letter)
    else
      @player.known_cards[letter] = pos
    end
  end

  def valid_pos?(input)
    return true if input.first >= 0 && input.first < self.grid.length && input.last >= 0 && input.last < self.grid.length
    puts "\nThat is an invalid position.  Please enter a valid position."
    false
  end

  def revealed_pos?(pos)
    return false unless self[pos].face_up
    puts "\nThat position has already been revealed.  Please enter a new position."
    true
  end

  def duplicate_pos?(pos_1, pos_2)
    return false unless pos_1 == pos_2
    puts "\nThat position was just entered.  Please enter a new position."
    true
  end

  def match?(guess_1_letter, guess_2_letter, guess_1_pos, guess_2_pos)
    if guess_1_letter == guess_2_letter
      self.store_match(guess_1_pos, guess_2_pos, guess_1_letter, guess_2_letter)
      @player.known_cards.delete_if { |k,v| k == guess_2_letter }
      self.correct_guess
    else
      incorrect_guess(guess_1_pos, guess_2_pos)
    end
  end

  def store_match(pos_1, pos_2, letter_1, letter_2)
    @player.matched_cards << pos_1
    @player.matched_cards << pos_2
  end

  def incorrect_guess(pos_1, pos_2)
    sleep(2)
    @attempts += 2
    puts "\nThey do not match. Please try again."
    self[pos_1].hide
    self[pos_2].hide
  end

  def correct_guess
    sleep(2)
    @pairs += 1
    @attempts += 2
    puts "\nIt's a match!"
    @player.paired_cards = Array.new
  end

  def game_over?
    if self.win? || self.lose?
      true
    else
      false
    end
  end

  def lose?
    if @player.attempts_left == 0
      self.clean_board
      self.render_board
      puts "\nYou lose.  You exceeded the number of attempts allowed."
      true
    else
      false
    end
  end
  
  def win?
    if @pairs == @size / 2
      self.clean_board
      self.render_board
      puts "\nCongratulations, you found all the pairs!"
      true
    else
      false
    end
  end

  def render_board
    50.times { print "-" }; puts ""
    
    print "  "
    (0...@grid.length).each { |num| print "#{num}" + " " }; puts ""
    
    @grid.each_with_index do |row, idx| 
      print "#{idx}" + " "
      row.each do |card| 
        if card.face_up
          print "#{card.face_up_value}" + " "
        else
          print "#{card.face_down_value}" + " "
        end
      end
      puts ""
    end
    
    self.pairs_and_attempts
    puts "ATTEMPTS LEFT: \##{@player.attempts_left}"
    50.times { print "-" }; puts ""
    self.cheat_mode
  end

  def cheat_mode
    puts "Known cards: #{@player.known_cards}"
    puts "Matches: #{@player.matched_cards}"
    puts "Pair: #{@player.paired_cards}"
    
    50.times { print "-" }; puts ""
  end

  def pairs_and_attempts
    puts "" if self.attempts == 0
    puts "\nYou found #{self.pairs} out of #{@size / 2} pairs with #{self.attempts} tries" if self.attempts > 1
  end
  
  def clean_board(n=0.5)
    sleep(n)
    system("clear")
  end

  def populate_board(n, letters)
    Array.new(n) { Array.new(n) { Card.new(letters.pop) } }
  end
  
  def generate_letters(n)
    letters = ("A".."Z").to_a
    generated_letters = []
    (n / 2).times do |num|
        generated_letters << letters[num]
        generated_letters << letters[num]
    end
    generated_letters.shuffle
  end
 
  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @grid[row][col] = val
  end

end


#binding.pry

#puts 'END'