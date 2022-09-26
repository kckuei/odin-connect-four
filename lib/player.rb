# frozen_string_literal: false

# A player class
#
# Attributes
#   @id - an integer representing generic player #
#   @avatar - string representing player avatar
#   @name - string representing user name
#   @wins - an integer representing user wins
#   @losses - an integer representing user losses
class Player
  attr_reader :id, :avatar, :name, :wins, :losses

  # Initializes Player instance
  def initialize(id, avatar)
    @id = id
    @avatar = avatar
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
