require_relative '../lib/connect_four'

describe Game do
  let(:white_circle) { described_class.new.white_circle }
  let(:black_circle) { described_class.new.black_circle }
  let(:empty_circle) { described_class.new.empty_circle }
  
  describe '#prompt_player_name' do 
    subject(:game) { described_class.new }
    before do
      allow(game).to receive(:gets).and_return('Bob')
    end
    it 'returns player name properly' do
      allow(game).to receive(:puts)
      player_name = game.prompt_player_name(1)
      expect(player_name).to eq('Bob')
    end
    it 'outputs correct message given an argument' do
      message = "Please enter player 1 name\n"
      expect{ game.prompt_player_name(1) }.to output(message).to_stdout
    end
  end

  describe '#set_player_name' do
    subject(:player_game) { described_class.new }
    let(:player_instance) { instance_double(Player) }
    it 'sends message to call prompt_player_name twice' do
      allow(player_instance).to receive(:name)
      expect(player_game).to receive(:prompt_player_name).twice
      player_game.set_player_name
    end
  end

  describe '#get_player_move' do 
    subject(:game) { described_class.new }
    let(:player) { instance_double("Player", name: "Bob") }
    before do
      allow(game).to receive(:gets).and_return('Bob')
      allow(game).to receive(:validate_player_move).and_return(true)
    end
    it 'outputs correct message given an argument' do 
      message = "Bob which column would you like to place your piece in\n"
      expect{ game.get_player_move(player) }.to output(message).to_stdout
    end
    it 'sends message to call #validate_player_move' do
      expect(game).to receive(:validate_player_move)
      game.get_player_move(player)
    end
  end

  describe '#validate_player_move' do 
    subject(:game_validate) { described_class.new }
    context 'with valid input' do
      it 'returns the valid move' do
        player_input_move = '5'
        result = game_validate.validate_player_move(player_input_move)
        expect(result).to eq(5)
      end
    end
    context 'with invalid input followed by valid input' do 
      it 'exits the loop and returns the valid move' do
        allow(game_validate).to receive(:puts)
        allow(game_validate).to receive(:gets).and_return("3\n")
        player_input_move = '20'
        result = game_validate.validate_player_move(player_input_move)
        expect(result).to eq(3)
      end
    end
  end

  describe '#next_turn' do 
    subject(:game_turn) { described_class.new }
    context 'when turn is updated' do 
      it 'increments the turn counter' do 
        initial_turn = game_turn.instance_variable_get(:@turn)
        expect {game_turn.next_turn}.to change {game_turn.instance_variable_get(:@turn)}.by(1)
      end
    end
  end

  describe '#player_turn' do 
    let(:player_one) { instance_double(Player) }
    let(:player_two) { instance_double(Player) }
    subject(:new_game) { described_class.new }
    it 'gets player move and sends message to call update_board' do
      board = new_game.instance_variable_get(:@game_board)
      allow(board).to receive(:display_board)
      allow(new_game).to receive(:get_player_move).and_return(3)
      allow(board).to receive(:next_available_row).and_return(5)
      allow(player_one).to receive(:symbol).and_return(white_circle)
      allow(player_two).to receive(:symbol).and_return(black_circle)
      turn = new_game.instance_variable_get(:@turn)
      new_game.instance_variable_set(:@current_player, player_one)
      expect(board).to receive(:update_board).with(5, 2, white_circle).once
      new_game.player_turn
    end
    it 'calls display_board properly' do
      expect(board).to receive(:display_board).once
    end
    it 'switches players correctly' do
    end

  end

  describe '#game_start' do 
  end
 
end

#Testing for the Board class will just check if updating the board / winning is correct
describe Board do
  let(:white_circle) { described_class.new.white_circle }
  let(:black_circle) { described_class.new.black_circle }
  let(:empty_circle) { described_class.new.empty_circle }

  describe '#initialize' do 
    subject(:board) { described_class.new }
    it 'properly initializes the 6 by 7 grid board' do
      empty_board = [
        [ empty_circle ] * 7,
        [ empty_circle ] * 7,
        [ empty_circle ] * 7,
        [ empty_circle ] * 7,
        [ empty_circle ] * 7,
        [ empty_circle ] * 7
      ]
      current_board = board.instance_variable_get(:@grid)
      expect(current_board).to eq(empty_board)
    end
  end

  describe '#update_board' do
    subject(:board_updated) { described_class.new }
    context 'when updating column 5, first row with white chip' do
      before do
        board_updated.update_board(5, 4, white_circle)
      end
      it 'updates the cell on the board in the first row' do 
        updated_board = board_updated.instance_variable_get(:@grid)
        first_row = 5
        fifth_column = 4
        result = updated_board[first_row][fifth_column]
        expect(result).to eq(white_circle)
      end
    end

    context 'when updating column 5 with a white chip and first row is not empty' do
      before do
        board_updated.update_board(4, 4, white_circle)
      end
      it 'updates the cell on top of the first row chip' do 
        first_row = 5
        second_row = 4
        fifth_column = 4
        updated_board = board_updated.instance_variable_get(:@grid)
        updated_board[first_row][fifth_column] = white_circle
        result = updated_board[second_row][fifth_column] 
        expect(result).to eq(white_circle)
      end
    end
  end

  describe '#next_available_row' do 
    subject(:board_row) { described_class.new }
    context 'when given a valid column as argument' do
      before do
        first_row = 5
        third_column = 2
        current_board = board_row.instance_variable_get(:@grid)
        current_board[first_row][third_column] = white_circle
      end
      it 'returns the available row number' do 
        second_row = 4
        third_column = 2
        result = board_row.next_available_row(third_column)
        expect(result).to eq(second_row)
      end
    end
  end

  describe '#column_full?' do
    subject(:board_column) { described_class.new }
    context 'when given a valid column as argument' do
      it 'returns true if column is full' do 
        current_board = board_column.instance_variable_get(:@grid)
        current_board[0][3] = white_circle
        current_board[1][3] = black_circle
        current_board[2][3] = white_circle
        current_board[3][3] = black_circle
        current_board[4][3] = white_circle
        current_board[5][3] = black_circle
        expect(board_column.column_full?(3)).to be(true)
      end

      it 'returns false if column is not full' do
        current_board = board_column.instance_variable_get(:@grid)
        current_board[1][3] = black_circle
        current_board[2][3] = white_circle
        current_board[3][3] = black_circle
        current_board[4][3] = white_circle
        current_board[5][3] = black_circle
        expect(board_column.column_full?(3)).to be(false)
      end
    end
  end

  describe '#check_horizontals' do
  subject(:board_horizontal) { described_class.new }
    context 'when checking for horizontal win condition' do
      it 'returns true if four in a row horizontally are the same symbol' do 
        current_board = board_horizontal.instance_variable_get(:@grid)
        current_board[5][2] = white_circle
        current_board[5][3] = white_circle
        current_board[5][4] = white_circle
        current_board[5][5] = white_circle
        expect(board_horizontal.check_horizontals(white_circle)).to be(true)
      end
      it 'returns false if not the same symbol' do 
        current_board = board_horizontal.instance_variable_get(:@grid)
        current_board[5][2] = white_circle
        current_board[5][3] = black_circle
        current_board[5][4] = white_circle
        current_board[5][5] = white_circle
        expect(board_horizontal.check_horizontals(white_circle)).to be(false)
      end
    end

  end
  describe '#check_diagonals' do
  subject(:board_diagonal) { described_class.new }
    context 'when checking for diagonal win condition' do
      it 'returns true if four in a row diagonally are the same symbol' do 
        current_board = board_diagonal.instance_variable_get(:@grid)
        current_board[5][2] = white_circle
        current_board[4][3] = white_circle
        current_board[3][4] = white_circle
        current_board[2][5] = white_circle
        expect(board_diagonal.check_diagonals(white_circle)).to be(true)
      end
      it 'returns false if not the same symbol' do 
        current_board = board_diagonal.instance_variable_get(:@grid)
        current_board[5][2] = white_circle
        current_board[5][3] = black_circle
        current_board[5][4] = white_circle
        current_board[5][5] = white_circle
        expect(board_diagonal.check_diagonals(white_circle)).to be(false)
      end
    end
  end
  describe '#check_verticals' do
    subject(:board_vertical) { described_class.new }
    context 'when checking for vertically win condition' do
      it 'returns true if four in a row vertically are the same symbol' do 
        current_board = board_vertical.instance_variable_get(:@grid)
        current_board[2][3] = white_circle
        current_board[3][3] = white_circle
        current_board[4][3] = white_circle
        current_board[5][3] = white_circle
        expect(board_vertical.check_verticals(white_circle)).to be(true)
      end
      it 'returns false if not the same symbol' do 
        current_board = board_vertical.instance_variable_get(:@grid)
        current_board[5][2] = white_circle
        current_board[5][3] = black_circle
        current_board[5][4] = white_circle
        current_board[5][5] = white_circle
        expect(board_vertical.check_verticals(white_circle)).to be(false)
      end
    end
  end
end

