# frozen_string_literal: true

require_relative '../lib/connect_four'

describe ConnectFour do
  describe '#validate_input' do
    subject(:game) { described_class.new }

    context 'when passed a valid string' do
      it 'returns true' do
        valid_input = '2'
        expect(game.validate_input(valid_input)).to be true
      end
    end

    context 'when passed an invalid string (symbols)' do
      before { allow(game).to receive(:puts) } # suppresses puts
      it 'returns false' do
        invalid_input = '@3!'
        expect(game.validate_input(invalid_input)).to be false
      end
    end

    context 'when passed an invalid string (negative)' do
      before { allow(game).to receive(:puts) } # suppresses puts
      it 'returns false' do
        invalid_input = '-1'
        expect(game.validate_input(invalid_input)).to be false
      end
    end
  end

  describe '#next_player' do
    subject(:game) { described_class.new }
    let(:player1) { double('player1', id: 1) }
    let(:player2) { double('player2', id: 2) }

    context 'when player 1 is the current player' do
      before do
        game.instance_variable_set(:@player1, player1)
        game.instance_variable_set(:@player1, player2)
        game.instance_variable_set(:@current_player, player1)
      end
      it 'changes curren player to player 2' do
        game.next_player
        expect(game.instance_variable_get(:@current_player)).to eq player2
      end
    end
  end
end

describe Player do
  describe '#ask_for_name' do
    subject(:player) { described_class.new(1, 'o') }

    context 'when a valid name is given' do
      before do
        allow(player).to receive(:puts) # suppresses puts
        allow(player).to receive(:gets).and_return('Kevin')
      end

      it 'the player name should update' do
        player.ask_for_name
        expect(player.name).to eq('Kevin')
      end
    end

    context 'when a an invalid (empty) name is given twice' do
      before do
        allow(player).to receive(:puts) # suppresses puts
        allow(player).to receive(:gets).and_return('', '', 'Kevin')
      end

      it 'should request user name at least three times' do
        expect(player).to receive(:gets).at_least(3).times
        player.ask_for_name
      end
    end
  end
end

describe Board do
  describe '#make_gameboard' do
    subject(:gboard) { described_class.new(6, 7) }

    context 'when it makes a game board' do
      it 'has 6 rows' do
        board = gboard.instance_variable_get(:@board)
        expect(board.length).to eq(6)
      end
      it 'has 7 columns' do
        board = gboard.instance_variable_get(:@board)
        expect(board[0].length).to eq(7)
      end
      it 'returns an empty nested 6 x 7 array' do
        board = gboard.instance_variable_get(:@board)
        board_expect = [
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '']
        ]
        expect(board).to eq board_expect
      end
    end
  end

  describe '#valid_move?' do
    subject(:gboard) { described_class.new(6, 7) }

    context 'when a move is not valid because the column is full' do
      it 'returns false' do
        move_on_column_index = 0
        board_invalid = [
          ['x', '', '', '', '', '', ''],
          ['o', '', '', '', '', '', ''],
          ['x', 'o', '', '', '', '', ''],
          ['x', 'x', 'x', 'x', '', '', ''],
          ['o', 'o', 'x', 'o', '', '', ''],
          ['x', 'x', 'o', 'o', '', '', 'o']
        ]
        gboard.instance_variable_set(:@board, board_invalid)
        expect(gboard.valid_move?(move_on_column_index)).to be false
      end
    end

    context 'when a move is valid' do
      it 'returns true' do
        move_on_column_index = 1
        board_invalid = [
          ['x', '', '', '', '', '', ''],
          ['o', '', '', '', '', '', ''],
          ['x', 'o', '', '', '', '', ''],
          ['x', 'x', 'x', 'x', '', '', ''],
          ['o', 'o', 'x', 'o', '', '', ''],
          ['x', 'x', 'o', 'o', '', '', 'o']
        ]
        gboard.instance_variable_set(:@board, board_invalid)
        expect(gboard.valid_move?(move_on_column_index)).to be true
      end
    end
  end

  describe '#update_board' do
    subject(:gboard) { described_class.new(6, 7) }

    context 'when player x adds a piece to col index 0 of an empty board' do
      it 'it falls to the bottom (x appears at [5][0])' do
        avatar = 'x'
        col_index = 0
        gboard.update_board(col_index, avatar)
        board = gboard.instance_variable_get(:@board)
        expect(board[5][0]).to eq('x')
      end
    end

    context 'when player x adds a piece to col index 6 of an empty board' do
      it 'it falls to the bottom (x appears at [5][6])' do
        avatar = 'x'
        col_index = 6
        gboard.update_board(col_index, avatar)
        board = gboard.instance_variable_get(:@board)
        expect(board[5][6]).to eq('x')
      end
    end

    context 'when player a piece is aded to a populated board' do
      it 'it falls on top of existing pieces' do
        board = [
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['x', '', '', '', 'x', '', ''],
          ['x', 'x', '', 'o', 'x', '', ''],
          ['o', 'o', 'x', 'o', 'o', '', ''],
          ['x', 'x', 'o', 'o', 'x', 'o', '']
        ]
        gboard.instance_variable_set(:@board, board)

        avatar = 'S'
        col_index = 2
        board_expect = [
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['x', '', '', '', 'x', '', ''],
          ['x', 'x', 'S', 'o', 'x', '', ''],
          ['o', 'o', 'x', 'o', 'o', '', ''],
          ['x', 'x', 'o', 'o', 'x', 'o', '']
        ]
        gboard.update_board(col_index, avatar)

        board = gboard.instance_variable_get(:@board)
        expect(board).to eq(board_expect)
      end
    end
  end

  describe '#horizontal_winner?' do
    subject(:gboard) { described_class.new(6, 7) }

    context 'when there is a horizontal winner - x' do
      it 'returns true' do
        avatar_winner = 'x'
        board_horizontal = [
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['x', 'x', 'x', 'x', '', '', ''],
          ['o', 'o', 'x', 'o', '', '', ''],
          ['x', 'x', 'o', 'o', '', '', 'o']
        ]
        gboard.instance_variable_set(:@board, board_horizontal)
        expect(gboard.horizontal_winner?(avatar_winner)).to be true
      end
    end

    context 'when there is no horizontal winner' do
      it 'returns false' do
        avatar_winner = 'x'
        board_horizontal = [
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['x', 'o', 'x', 'x', '', '', ''],
          ['o', 'o', 'x', 'o', '', '', ''],
          ['x', 'x', 'o', 'x', '', '', 'o']
        ]
        gboard.instance_variable_set(:@board, board_horizontal)
        expect(gboard.horizontal_winner?(avatar_winner)).to be false
      end
    end
  end

  describe '#vertical_winner?' do
    subject(:gboard) { described_class.new(6, 7) }

    context 'when there is a vertical winner - o' do
      it 'returns true' do
        avatar_winner = 'o'
        board_vertical = [
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', 'o', '', '', '', ''],
          ['x', 'x', 'o', 'x', 'x', '', ''],
          ['o', 'o', 'o', 'o', 'x', '', 'x'],
          ['x', 'x', 'o', 'o', 'x', '', 'o']
        ]
        gboard.instance_variable_set(:@board, board_vertical)
        expect(gboard.vertical_winner?(avatar_winner)).to be true
      end
    end

    context 'when there is no vertical winner' do
      it 'returns false' do
        avatar_winner = 'o'
        board_vertical = [
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', 'o', '', 'o', '', ''],
          ['x', 'x', 'o', 'x', 'x', '', ''],
          ['o', 'o', 'x', 'o', 'x', '', 'x'],
          ['x', 'x', 'o', 'o', 'x', '', 'o']
        ]
        gboard.instance_variable_set(:@board, board_vertical)
        expect(gboard.vertical_winner?(avatar_winner)).to be false
      end
    end
  end

  describe '#diaganol_winner?' do
    subject(:gboard) { described_class.new(6, 7) }

    context 'when there is a diaganol winner - x - bl_tr' do
      it 'returns true' do
        avatar_winner = 'x'
        board_diag = [
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['x', 'x', 'o', 'o', 'x', '', ''],
          ['x', 'x', 'o', 'x', 'x', '', ''],
          ['o', 'o', 'x', 'o', 'o', '', ''],
          ['x', 'x', 'o', 'o', 'x', '', '']
        ]
        gboard.instance_variable_set(:@board, board_diag)
        expect(gboard.diaganol_winner?(avatar_winner)).to be true
      end
    end

    context 'when there is a diaganol winner - o - tl_br' do
      it 'returns true' do
        avatar_winner = 'o'
        board_diag = [
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['o', 'x', 'o', 'o', 'x', '', ''],
          ['x', 'o', 'x', 'x', 'x', '', ''],
          ['o', 'x', 'o', 'o', 'o', '', ''],
          ['x', 'x', 'o', 'o', 'x', '', '']
        ]
        gboard.instance_variable_set(:@board, board_diag)
        expect(gboard.diaganol_winner?(avatar_winner)).to be true
      end
    end

    context 'when there is no diaganol winner - o' do
      it 'returns false' do
        avatar = 'o'
        board_diag = [
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['x', '', '', '', 'x', '', ''],
          ['x', 'x', '', 'o', 'x', '', ''],
          ['o', 'o', 'x', 'o', 'o', '', ''],
          ['x', 'x', 'o', 'o', 'x', 'o', '']
        ]
        gboard.instance_variable_set(:@board, board_diag)
        expect(gboard.diaganol_winner?(avatar)).to be false
      end
    end

    context 'when there is no diaganol winner - x' do
      it 'returns false' do
        avatar = 'x'
        board_diag = [
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['x', '', '', '', 'x', '', ''],
          ['x', 'x', '', 'o', 'x', '', ''],
          ['o', 'o', 'x', 'o', 'o', '', ''],
          ['x', 'x', 'o', 'o', 'x', 'o', '']
        ]
        gboard.instance_variable_set(:@board, board_diag)
        expect(gboard.diaganol_winner?(avatar)).to be false
      end
    end
  end

  describe '#game_over?' do
    subject(:gboard) { described_class.new(6, 7) }

    context 'when the board is full and no winner' do
      it 'returns true' do
        avatars = %w[o x]
        board_draw = [
          %w[o x o o x o o],
          %w[x o x x o x x],
          %w[o x o o x o o],
          %w[x o x x o x x],
          %w[o x o o x o o],
          %w[x o x x o x x]
        ]
        gboard.instance_variable_set(:@board, board_draw)
        expect(gboard.game_over?(avatars)).to be true
      end
    end
  end
end
