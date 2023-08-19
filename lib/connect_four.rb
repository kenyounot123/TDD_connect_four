module Symbols
  def white_circle 
    "\u25EF"
  end
  def black_circle
    "\u26AB"
  end
  def empty_circle
    "\u25cb"
  end
end

#Make sure that when getting user input on the column, we have to - 1 to it.
class Board
  include Symbols
  attr_reader :grid
  def initialize
    @grid = Array.new(6) { Array.new(7) {empty_circle} }
  end

  def display_board
    @grid.each do |row|
      puts row.join(' ')
    end
    puts (1..7).to_a.join(' ')
  end

  def update_board(row, column, symbol)
    @grid[row][column] = symbol
  end

  def next_available_row(column)
    available_row = 0
    for row in (0...6)
      if @grid[row][column] != empty_circle
        available_row = row - 1 
        break
      end
    end
    available_row
  end
  
  def column_full?(column)
    column_full = false
    return true if next_available_row(column) == -1
    column_full
  end

  def check_diagonals(symbol)
    #check bottom left to top right diagonals
    #check bottom right to top left diagonals
    rows = (0..2)
    columns = (0..3)
    rows.each do |row|
      columns.each do |column|
        section = (0..3).map { |i| @grid[row + i][column + i] }
        return true if section.all? { |chip| chip == symbol }
      end
    end

    rows.each do |row|
      columns.each do |column|
        section = (0..3).map { |i| @grid[row + 3 - i][column + i] }
        return true if section.all? { |chip| chip == symbol }
      end
    end
    false
  end

  #each column has 4 vertical sections to check
  def check_verticals(symbol)
    rows = (0..3)
    columns = (0..5)
    rows.each do |row|
      columns.each do |column|
        section = @grid[row..row + 3].map { |consecutive_row| consecutive_row[column]}
        return true if section.all? { |chip| chip == symbol }
      end
    end
    false
  end

  #each row has 4 sections to check
  def check_horizontals(symbol)
    rows = (0..5)
    columns = (0..3)
    rows.each do |row|
      columns.each do |column|
        section = @grid[row][column..column + 3]
        return true if section.all? { |chip| chip == symbol }
      end
    end
    false
  end
end

class Game
  include Symbols
  def intro_message
    <<~HEREDOC 

    This is Connect four and it will be played in the console. 

    Rules are simple, connect four of the same colored chip to win.
    Four in a row, vertically, horizontally, or diagonally all work!

    You will be playing against another player while taking turns to play a piece.
    To play a piece, type in which column you would like to drop your chip in,
    first column being (1).

    HEREDOC
  end
  def initialize
    @game_board = Board.new()
    @player_one = Player.new(nil, white_circle)
    @player_two = Player.new(nil, black_circle)
  end

  #the only user input there will be is for choosing column and inputting name
  #will return validated user input
  def validate_user_input

  end

  def player_turn
  end

  def game_start
    puts intro_message
    set_player_name
    player_turn


  end

  def prompt_player_name(player_number)
    puts "Please enter player #{player_number} name"
    player_name = gets.chomp
    player_name
  end
    
  def set_player_name
    @player_one.name = prompt_player_name(1)
    @player_two.name = prompt_player_name(2)
  end

end

class Player
  attr_accessor :name, :symbol
  def initialize(name, symbol)
    @symbol = symbol
    @name = name
  end
end



grid = Board.new
grid.display_board
