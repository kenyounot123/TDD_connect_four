require_relative '../lib/connect_four'

describe Game do
  
end

#Testing for the Board class will just check if updating the board / winning is correct
describe Board do
  subject(:board) { described_class.new }
  let(:white_circle) { described_class.new.white_circle }
  let(:black_circle) { described_class.new.black_circle }
  let(:empty_circle) { described_class.new.empty_circle}

  describe '#initialize' do 
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
    context 'when updating column 5 with a white chip and starting with empty board' do
      before do
        board.update_board(5, white_circle)
      end
      it 'updates the cell on the board in the first row' do 
        updated_board = instance_variable_get(:@grid)
        first_row = 5
        fifth_column = 5 - 1
        result = updated_board[first_row, fifth_column]
        expect(result).to eq(white_circle)
      end
    end

    context 'when updating column 5 with a white chip and first row is not empty'
    before do
      first_row = 5
      fifth_column = 5 - 1
      updated_board = instance_variable_get(:@grid)
      board.update_board(5, white_circle)
    end
    it 'updates the cell on top of the first row chip' do 
      second_row = 4
      fifth_column = 5 - 1
      updated_board[first_row, fifth_column] = white_circle
      result = updated_board[second_row, fifth_column] 
      expect(result).to eq(white_circle)
    end
  end
end