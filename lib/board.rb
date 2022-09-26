# frozen_string_literal: false

# Board class for connect4 game.
#
# You can instantiate a 2D game board of arbitrary size. Various methods are implemented
# for plotting the board, updating or resetting the board, validating moves, and checking for
# winning conditions (horizontal, vertical, diaganol).
#
# Attributes
#   @rows - an integer representing number of rows (default 6)
#   @columns - an integer representing number of columns (default 7)
#   @board - a nested array, representing the 2D board ('' denotes empty slot)
#   @mapping - 1D to 2D mapping (not used)
#   @diaganols - a nested array, representing all the diaganols to check for a win condition
class Board
  attr_reader :rows, :columns

  # Initializes Board instance.
  def initialize(rows = 6, columns = 7)
    @rows = rows
    @columns = columns
    @board = make_gameboard(rows, columns)
    @mapping = make_mapping(rows, columns)
    @diaganols = form_diaganols
  end

  # Creates game board of height rows, width columns.
  def make_gameboard(rows, columns)
    board = []
    rows.times { board << Array.new(columns, '') }
    board
  end

  # Resets game board to empty.
  def reset_board
    @board = make_gameboard(@rows, @columns)
  end

  # Creates 1D to 2D game board mapping.
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

  # Draws the board, including pieces.
  # show_open_moves flag is for showing tiled numbers.
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
    puts "\n" << (0..@columns - 1).reduce(' ') { |a, i| a << i.to_s.ljust(4, ' ') } << "\n\n"
  end

  # Adds consistent padding so board draws correctly.
  # Supports draw_board.
  def format(val)
    val.to_s.center(3, ' ')
  end

  # Draw value
  # Supports draw_board.
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

  # Draw divider.
  # Supports draw_board.
  def draw_divider
    print "\e[91m║\e[0m"
  end

  # Draws a row.
  # Supports draw_board.
  def draw_row
    row = "\n"
    (@columns - 1).times { row << "\e[91m═══╬\e[0m" }
    row << "\e[91m═══\e[0m"
    puts row
  end

  # Updates the board given a column index.
  def update_board(col_idx, avatar)
    return unless valid_move?(col_idx)

    # functions like a #reverse_each_wth_index
    # It drops a value into the board from the bottom up by finding first nil.
    @board.to_enum.with_index.reverse_each do |row, row_idx|
      if row[col_idx].empty?
        @board[row_idx][col_idx] = avatar
        break
      end
    end
  end

  # Checks if the specified columns index is a valid move.
  def valid_move?(col_idx)
    column = @board.reduce([]) { |a, row| a << row[col_idx] }
    col_idx >= 0 && col_idx < @columns && column.count('').positive?
  end

  # Updates the board value at a specific location.
  def update_point(point, avatar)
    return unless valid_move_by_point?(point)

    @board[point[0]][point[1]] = avatar
    @board
  end

  # Given a specific point, checks if it is a valid move.
  def valid_move_by_point?(point)
    return false unless inside_board?(point) && @board[point[0]][point[1]]

    true
  end

  # Checks if point is inside board.
  def inside_board?(point)
    x, y = point
    return true if x >= 0 && x < @rows && y >= 0 && y < @columns

    false
  end

  # Given an iterable, counts the occurences of contiguous avatars.
  def max_count(iterable, avatar)
    count = max_len = 0
    iterable.each do |val|
      val == avatar ? count += 1 : count = 0
      max_len = count if count > max_len
    end
    max_len
  end

  # Checks for horizontal winning condition (contiguous connect 4).
  def horizontal_winner?(avatar)
    @board.each do |row|
      len = max_count(row, avatar)
      return true if len >= 4
    end
    false
  end

  # Checks for vertical winning condition (contiguous connect 4).
  def vertical_winner?(avatar)
    @columns.times do |i|
      col = @board.reduce([]) { |a, row| a << row[i] }
      len = max_count(col, avatar)
      return true if len >= 4
    end
    false
  end

  # Check for diaganol winning condition (contiguous connect 4).
  def diaganol_winner?(avatar)
    @diaganols.each do |diag|
      values = get_diaganol_values(diag)
      return true if max_count(values, avatar) >= 4
    end
    false
  end

  # Get the base squares of the game board that are used to seed diaganol lines.
  # Supports diaganol_winner?.
  def diaganol_seeds
    # Squares corresponding to left/top edges (top-left -> bottom-right)
    tl_br = []
    (0..@columns - 1).each { |i| tl_br << [0, i] }
    (1..@rows - 1).each { |i| tl_br << [i, 0] }

    # Squares corresponding to left/bottom edges  (bottom-left -> top-right)
    bl_tr = []
    (0..@rows - 1).each { |i| bl_tr << [i, 0] }
    (1..@columns - 1).each { |i| bl_tr << [5, i] }

    [tl_br, bl_tr]
  end

  # Forms diaganol lines from the base squares given by diaganol_seeds.
  # The maximum length of a given diaganol is constrained by the number of rows.
  # Each base square is extended by rows-1 times, keeping only those points residing inside the board.
  # Supports diaganol_winner?.
  def form_diaganols
    tl_br, bl_tr = diaganol_seeds
    all_diaganols = []
    tl_br.each do |base|
      diaganol = [base]
      (@rows - 1).times do |i|
        offset = i + 1
        next_point = [base[0] + offset, base[1] + offset]
        diaganol << next_point if inside_board?(next_point)
      end
      all_diaganols << diaganol
    end

    bl_tr.each do |base|
      diaganol = [base]
      (@rows - 1).times do |i|
        offset = i + 1
        next_point = [base[0] - offset, base[1] + offset]
        diaganol << next_point if inside_board?(next_point)
      end
      all_diaganols << diaganol
    end
    all_diaganols
  end

  # Given an array representing diaganol points, returns an array of the board values
  # Supports diaganol_winner?.
  def get_diaganol_values(diaganol_points)
    values = []
    diaganol_points.each do |points|
      i, j = points
      values << @board[i][j]
    end
    values
  end

  # Check for an overall winning condition.
  def winner?(avatars)
    avatars.each do |avatar|
      return true if horizontal_winner?(avatar) || vertical_winner?(avatar) || diaganol_winner?(avatar)
    end
    false
  end

  # Checks if the game is over.
  # The game is over if we have a winner or there are no more free spaces.
  def game_over?(avatars)
    winner?(avatars) || @board.flatten.count('').zero?
  end
end
