require_relative 'symbols'
require_relative 'player'

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
    if @grid[5][column] == empty_circle
      available_row = 5
    end
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
    rows = (0..2)
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