require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/symbols'
require_relative '../lib/board'


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
    before do
      allow(new_game).to receive(:get_player_move).and_return(3)
      allow(player_one).to receive(:symbol).and_return(white_circle)
      allow(player_two).to receive(:symbol).and_return(black_circle)
    end
    it 'gets player move and sends message to call update_board' do
      board = new_game.instance_variable_get(:@game_board)
      allow(board).to receive(:display_board)
      allow(board).to receive(:next_available_row).and_return(5)
      new_game.instance_variable_set(:@current_player, player_one)
      expect(board).to receive(:update_board).with(5, 2, white_circle).once
      new_game.player_turn
    end
    it 'calls display_board properly' do
      board = new_game.instance_variable_get(:@game_board)
      expect(board).to receive(:display_board).once
      new_game.player_turn
    end
    context 'when turn is odd' do
      it 'sets @current_player to be @player_one' do
        board = new_game.instance_variable_get(:@game_board)
        allow(board).to receive(:display_board)
        new_game.instance_variable_set(:@turn, 1)
        new_game.instance_variable_set(:@player_one, player_one)
        new_game.player_turn
        expect(new_game.instance_variable_get(:@current_player)).to eq(player_one)
      end
    end
    context 'when turn is even' do 
      it 'sets @current_player to be @player_two' do
        board = new_game.instance_variable_get(:@game_board)
        allow(board).to receive(:display_board)
        new_game.instance_variable_set(:@turn, 2)
        new_game.instance_variable_set(:@player_two, player_two)
        new_game.player_turn
        expect(new_game.instance_variable_get(:@current_player)).to eq(player_two)
      end
    end
  end
  describe '#game_over?' do 
    subject(:winner_game) { described_class.new }
    context 'when a win condition is satisfied' do 
      before do
        game_board = winner_game.instance_variable_get(:@game_board)
        allow(game_board).to receive(:check_diagonals).and_return(true) 
        allow(game_board).to receive(:check_horizontals).and_return(false) 
        allow(game_board).to receive(:check_verticals).and_return(false) 
      end
      it 'returns true' do
        expect(winner_game.game_over?(white_circle)).to be(true)
      end
    end
    context 'when win condition is not met' do 
      before do
        game_board = winner_game.instance_variable_get(:@game_board)
        allow(game_board).to receive(:check_diagonals).and_return(false) 
        allow(game_board).to receive(:check_horizontals).and_return(false) 
        allow(game_board).to receive(:check_verticals).and_return(false) 
      end
      it 'returns false' do 
        expect(winner_game.game_over?(white_circle)).to be(false)
      end
    end
  end

  describe '#game_draw?' do 
    subject(:game_draw) { described_class.new }
    it 'returns true if no win conditions are satisfied and @turn is 43' do 
      game_draw.instance_variable_set(:@turn, 43)
      allow(game_draw).to receive(:game_over?).and_return(false)
      expect(game_draw.game_draw?).to be(true)
    end
    it 'returns false if @turn is less than 43' do
      game_draw.instance_variable_set(:@turn, 23)
      allow(game_draw).to receive(:game_over?).and_return(true)
      expect(game_draw.game_draw?).to be(false)
    end
    it 'returns false if there is a winner' do
      game_draw.instance_variable_set(:@turn, 43)
      allow(game_draw).to receive(:game_over?).and_return(true)
      expect(game_draw.game_draw?).to be(false)
    end
  end

 
  describe '#display_winner' do
    subject(:game_winner) { described_class.new }
    let(:player) { instance_double(Player) }
    it 'prints message using argument given' do
      player_name = 'Steven'
      allow(player).to receive(:name).and_return(player_name)
      winner_message = "Congratulations Steven, you win!\n"
      expect{game_winner.display_winner(player)}.to output(winner_message).to_stdout
    end
  end
end