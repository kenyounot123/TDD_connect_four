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

  def check_diagonals
  end

  def check_verticals
  end

  def check_horizontals
  end
end

class Game
  include Symbols
  def intro_message
    <<~HEREDOC 

    This is Connect four and it will be played in the console. 

    Rules are simple, connect four of the same colored chip to win.
    Four in a row, vertically, horizontally, or diagonally all work!

    To play a piece, type in which column you would like to drop your chip in,
    first column being (1).

    HEREDOC
  end

end

class Player
end



grid = Board.new
grid.display_board
