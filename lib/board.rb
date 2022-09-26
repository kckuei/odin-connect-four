# frozen_string_literal: false

# Board class for connect4 game.
#
# Attributes
#   @rows - an int representing number of rows (default 6)
#   @columns - an int representing number of columns (default 7)
#   @board - a nested array, representing the 2D board ('' denotes empty slot)
#   @mapping - 1D to 2D mapping (not used)
class Board
  attr_accessor :board # TEMPORARY ACCESSOR FOR TESTING

  # Initializes Board instance
  def initialize(rows = 6, columns = 7)
    @rows = rows
    @columns = columns
    @board = make_gameboard(rows, columns)
    @mapping = make_mapping(rows, columns)
  end

  # Creates game board
  def make_gameboard(rows, columns)
    board = []
    rows.times { board << Array.new(columns, '') }
    board
  end

  # Creates 1D to 2D game board mapping
  # Not required for for this game, but useful for tiling numbers if desired.
  # Can also be used to implement an alternative move specificiation.
  def make_mapping(rows, columns)
    id = 0
    grid_map = Hash.new(false)
    (0..rows - 1).each do |i|
      (0..columns - 1).each do |j|
        id += 1
        grid_map[id] = [i, j]
      end
    end
    grid_map
  end

  # Draws the board
  def draw_board(show_open_moves = false)
    k = 0
    (0..@rows - 1).each do |i|
      (0..@columns - 1).each do |j|
        k += 1
        draw_value(@board[i][j], k, show_open_moves)
        draw_divider if j < @columns - 1
      end
      draw_row if i < @rows - 1
    end
    puts "\n\n"
  end

  # Pads values, supports draw_board
  def format(val)
    val.to_s.rjust(3, ' ')
  end

  # Draw value, supports draw_board
  def draw_value(val, idx, show_open_moves)
    if val.empty?
      if show_open_moves
        print format(idx)
      else
        print format('')
      end
    else
      print format(val)
    end
  end

  # Draw divider, supports draw_board
  def draw_divider
    print '║'
  end

  # Draws a row, supports draw_board
  def draw_row
    row = "\n"
    (@columns - 1).times { row << '═══╬' }
    row << '═══'
    puts row
  end

  # Updates the board given a column
  def update_board(col_idx, avatar)
    return unless valid_move?(col_idx)

    # functions like .reverse_each_wth_index
    # drops a value intot he board from bottom up
    @board.to_enum.with_index.reverse_each do |row, row_idx|
      if row[col_idx].empty?
        @board[row_idx][col_idx] = avatar
        break
      end
    end
  end

  # Checks if valid player move
  def valid_move?(col_idx)
    column = @board.reduce([]) { |a, row| a << row[col_idx] }
    col_idx >= 0 && col_idx < @columns && column.count('').positive?
  end

  # Updates the board value at a specific location
  def update_point(point, avatar)
    return unless valid_move_by_point?(point)

    @board[point[0]][point[1]] = avatar
    @board
  end

  # Given a specific point, checks if it is a valid move
  def valid_move_by_point?(point)
    return false unless inside_board?(point) && @board[point[0]][point[1]]

    true
  end

  # Checks if point is inside board
  def inside_board?(point)
    x, y = point
    return true if x >= 0 && x < @rows && y >= 0 && y < @columns

    false
  end

  # Given an iterable, counts the occurences of contiguous avatars
  def max_count(iterable, avatar)
    count = max_len = 0
    iterable.each do |val|
      val == avatar ? count += 1 : count = 0
      max_len = count if count > max_len
    end
    max_len
  end

  # Check horizontal winner condition, contiguous
  def horizontal_winner?(avatar)
    @board.each do |row|
      len = max_count(row, avatar)
      return true if len >= 4
    end
    false
  end

  # Check vertical winner condition, contiguous
  def vertical_winner?(avatar)
    @columns.times do |i|
      col = @board.reduce([]) { |a, row| a << row[i] }
      len = max_count(col, avatar)
      return true if len >= 4
    end
    false
  end

  # Check diaganol winner condition, contiguous
  def diaganol_winner?(avatar)
    # TO DO TO DO TO DO
  end

  # Check overall winner condition
  def winner?(avatars)
    avatars.each do |avatar|
      return true if horizontal_winner?(avatar) || vertical_winner?(avatar) || diaganol_winner?(avatar)
    end
    false
  end

  # Check if game over
  def game_over?(avatars)
    winner?(avatars) || board.flatten.count('').zero?
  end
end
