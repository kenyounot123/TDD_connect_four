require_relative 'player'
require_relative 'symbols'
require_relative 'board'

class Game
  include Symbols
  def intro_message
    puts <<~HEREDOC 

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
    @turn = 1
  end

  #the only user input there will be is for choosing column and inputting name
  #will return validated user input
  def validate_player_move(move)
    until move.to_i.between?(1,7)
      puts "Please type in a valid column number" 
      move = gets.chomp
    end
    move.to_i
  end

  def game_over?(symbol)
    @game_board.check_diagonals(symbol) ||  @game_board.check_horizontals(symbol) ||  @game_board.check_verticals(symbol)
  end

  def player_turn
    if @turn % 2 == 0
      @current_player = @player_two
    else
      @current_player = @player_one
    end
    move = get_player_move(@current_player)
    column = move - 1
    @game_board.update_board(@game_board.next_available_row(column), column, @current_player.symbol)
    @game_board.display_board
  end

  def game_start
    intro_message
    set_player_name
    @game_board.display_board
    loop do 
      player_turn
      next_turn
      break if game_over?(@current_player.symbol) || game_draw?
    end
    display_winner(@current_player) 
  end
  def game_draw?
    @turn == 43 && game_over?(white_circle) == false && game_over?(black_circle) == false
  end

  def display_winner(player)
    puts "Congratulations #{player.name}, you win!"
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

  def get_player_move(player)
    puts "#{player.name} which column would you like to place your piece in"
    player_move = gets.chomp
    validate_player_move(player_move)
  end

  def next_turn
    @turn += 1
    @turn
  end

end