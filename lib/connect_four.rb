# frozen_string_literal: false

require_relative './board'
require_relative './player'
require_relative './intro'

# ConnectFour class for playing a Connect Four game.
#
# Attributes
#   @board - Board class, representing game board
#   @player1 - Player class, representing player 1
#   @player2 - Player class, representing player 2
class ConnectFour
  def make_gameboard(rows = 6, columns = 7)
    @board = Board.new(rows, columns)
    @player1 = nil
    @player2 = nil
  end

  # Displays title intro
  def show_intro
    Intro.new.show_intro
  end

  # Plays one full game loop
  def game_loop
    loop do
      # display the initial board and query for input
      # get player input (and validate input)
      # update the board
      # display the board
      # check for win or end_game condition
      # if win or end_game condition
      #   update player scores
      #   display winner and scoreboard
      #   hit any key to continue
      #   reset gameboard
      # else break from loop
    end
  end

  # Initiates the game
  def play
    show_intro
    puts 'Player 1:'
    @player1 = Player.new
    puts 'Player 2:'
    @player2 = Player.new
    game_loop
    play
  end
end
