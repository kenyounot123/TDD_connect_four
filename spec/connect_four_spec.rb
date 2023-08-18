require_relative '../lib/connect_four'

describe Game do
  
end

#Testing for the Board class will just check if updating the board / winning is correct
describe Board do
  let(:white_circle) { described_class.new.white_circle }
  let(:black_circle) { described_class.new.black_circle }
  let(:empty_circle) { described_class.new.empty_circle}

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
        first_row = 6 - 1
        fifth_column = 5 - 1
        result = updated_board[first_row][fifth_column]
        expect(result).to eq(white_circle)
      end
    end

    context 'when updating column 5 with a white chip and first row is not empty' do
      before do
        board_updated.update_board(4, 4, white_circle)
      end
      it 'updates the cell on top of the first row chip' do 
        first_row = 6 - 1
        second_row = 5 - 1
        fifth_column = 5 - 1
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
        first_row = 6 - 1
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
  
end