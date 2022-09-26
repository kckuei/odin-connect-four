# frozen_string_literal: true

require_relative './board'
require_relative './player'

# Connect Four class for playing a connect4 game
class ConnectFour
  def make_gameboard(rows = 6, columns = 7)
    @board = Board.new(rows, columns)
    @player1 = nil
    @player2 = nil
  end
end
