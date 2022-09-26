# frozen_string_literal: true

require_relative '../lib/connect_four'

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

  describe '#horizontal_winner?' do
    subject(:gboard) { described_class.new(6, 7) }

    context 'when there is a horizontal winner' do
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

    context 'when there is a vertical winner' do
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
    context 'when there is a diaganol winner' do
      xit 'returns true' do
      end
    end
    context 'when there is no diaganol winner' do
      xit 'returns false' do
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
