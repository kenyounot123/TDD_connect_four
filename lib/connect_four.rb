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
  def update_board(column, symbol)
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