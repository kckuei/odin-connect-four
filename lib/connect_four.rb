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
#   @current_player - Player class, representing current players turn to move
class ConnectFour
  def initialize(rows = 6, columns = 7)
    @board = Board.new(rows, columns)
    @player1 = nil
    @player2 = nil
    @current_player = nil
  end

  # Gets player input, parses the string and returns an integer.
  def user_input
    input = gets.chomp
    input = gets.chomp until validate_input(input)
    input.to_i
  end

  # Validates player input string.
  # User must enter an integer between 0 and number of columns - 1 to be valid.
  def validate_input(string)
    if string.match(/\A[0-9]*\z/).nil? || string.to_i.negative? || string.to_i >= @board.columns
      puts "Invalid input. Enter a column number: 0-#{@board.columns - 1}."
      return false
    end
    unless @board.valid_move?(string.to_i)
      puts "You cannot move there. Enter a column number: 0-#{@board.columns - 1}."
      return false
    end
    true
  end

  # Alternates between player turns.
  def next_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  # Shows the board, queries a move, and updates the board with the player move.
  def player_moves
    puts "\nPlayer #{@current_player.id} (#{@current_player.avatar}): #{@current_player.name} turn:"
    puts "Enter a column number: 0-#{@board.columns - 1}.\n\n"
    @board.draw_board
    @board.update_board(user_input, @current_player.avatar)
    @board.draw_board
  end

  # Plays one full game loop.
  def game_loop
    loop do
      player_moves
      next_player
      next unless @board.game_over?([@player1.avatar, @player2.avatar])

      declare_winner_scores_and_reset
      break
    end
  end

  # Declares the winner of the game, shows the scoreboard, and waits for user input to continue new game.
  def declare_winner_scores_and_reset
    display_winner_message
    scoreboard
    @board.reset_board
    puts "\nPress any key to continue playing."
    gets
  end

  # Declares the winner (or tie) and increments player scores.
  def display_winner_message
    if @board.winner?([@player1.avatar])
      @player1.increment_win
      @player2.increment_loss
      return puts "CONNECT 4! Player 1: #{@player1.name} (#{@player1.avatar}) wins!"
    elsif @board.winner?([@player2.avatar])
      @player2.increment_win
      @player1.increment_loss
      return puts "CONNECT 4! Player 2: #{@player2.name} (#{@player2.avatar}) wins!"
    end
    puts "It's a draw!"
  end

  # Displays running score over all games played.
  def scoreboard
    puts "\nS C O R E B O A R D:"
    puts "Player #{@player1.id} (#{@player1.avatar}): #{@player1.name.ljust(10, ' ')} wins: #{@player1.wins}"
    puts "Player #{@player2.id} (#{@player2.avatar}): #{@player2.name.ljust(10, ' ')} wins: #{@player2.wins}"
  end

  # Initiates the game.
  def play
    Intro.new.show_intro
    assign_players
    main_loop
  end

  # Main loop to keep playing.
  def main_loop
    @current_player = @player1
    game_loop
    main_loop
  end

  # Assigns player 1 and player 2.
  def assign_players
    puts 'Player 1:'
    @player1 = Player.new(1, '●')
    puts "\nPlayer 2:"
    @player2 = Player.new(2, '◌')
  end
end
