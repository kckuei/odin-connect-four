# frozen_string_literal: true

# A player class
#
# Attributes
#   @name - string representing user name
#   @wins - an integer representing user wins
#   @losses - an integer representing user losses
class Player
  # Initializes Player instance
  def initialize
    @name = ask_for_name
    @wins = 0
    @losses = 0
  end

  # Asks for the user name
  def ask_for_name
    puts 'Enter a user name'
    user_name = gets.chomp
    loop do
      break if user_name.length.positive?

      puts 'Enter a user name'
      user_name = gets.chomp
    end
    user_name
  end

  # Increments the wins
  def increment_win
    @wins += 1
  end

  # Increments the losses
  def increment_loss
    @losses += 1
  end
end
