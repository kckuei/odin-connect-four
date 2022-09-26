require_relative './board'
require_relative './intro'

@board = [
  ['', '', '', '', '', '', ''],
  ['', '', '', '', '', '', ''],
  ['', '', '', '', '', '', ''],
  ['x', '', '', '', '', '', ''],
  ['o', 'o', 'x', '', '', '', ''],
  ['x', 'x', 'o', 'o', '', '', '']
]

@rows = @board.length
@columns = @board[0].length

new_board = Board.new
new_board.board = @board
new_board.draw_board
new_board.update_board(6, 's')
new_board.draw_board
new_board.update_board(2, 's')
new_board.draw_board

idx = 0
col = new_board.board.reduce([]) { |a, row| a << row[idx] }
puts col.count('')

intro = Intro.new
intro.show_intro

@board = [
  %w[T x o o x o J],
  %w[x o x x o x x],
  %w[o x o x x o o],
  %w[x o x x o x x],
  %w[o x o o x o o],
  %w[H o x x o x L]
]
puts @board[0][0]
puts @board[0][6]
puts @board[5][6]
puts @board[5][0]

@board = [
  %w[o x o o x o o],
  %w[x o x x o x x],
  %w[o x o x x o o],
  %w[x o x x o x x],
  %w[o x o o x o o],
  %w[x o x x o x x]
]

# Checks if point is inside board
def inside_board?(point)
  x, y = point
  return true if x >= 0 && x < @rows && y >= 0 && y < @columns

  false
end

def max_count(iterable, avatar)
  count = max_len = 0
  iterable.each do |val|
    val == avatar ? count += 1 : count = 0
    max_len = count if count > max_len
  end
  max_len
end

@rows = 6
@cols = 7
# These are base/seed squares corresponding to the left/top edges
list_TL_BR = []
(0..@cols - 1).each { |i| list_TL_BR << [0, i] }
(1..@rows - 1).each { |i| list_TL_BR << [i, 0] }
p list_TL_BR

# These are the base/seed squares corresponding to the left/bottom edges
list_BL_TR = []
(0..@rows - 1).each { |i| list_BL_TR << [i, 0] }
(1..@cols - 1).each { |i| list_BL_TR << [5, i] }
p list_BL_TR

# We will form diaganol lines from the base squares in their respective
# directions. The maximum diaganol is constrained by the number of rows.
# So we want to extend each of the base/seed squares by rows-1 times.
all_diaganols = []
list_TL_BR.each do |base|
  diaganol = [base]
  (@rows - 1).times do |i|
    offset = i + 1
    next_point = [base[0] + offset, base[1] + offset]
    diaganol << next_point if inside_board?(next_point)
  end
  p diaganol
  all_diaganols << diaganol
end

list_BL_TR.each do |base|
  diaganol = [base]
  (@rows - 1).times do |i|
    offset = i + 1
    next_point = [base[0] - offset, base[1] + offset]
    diaganol << next_point if inside_board?(next_point)
  end
  p diaganol
  all_diaganols << diaganol
end

# we must check all the lines in all_diaganols
def get_diaganol_values(diaganol_points)
  values = []
  diaganol_points.each do |points|
    i, j = points
    values << @board[i][j]
  end
  values
end

idx = 15
puts "diaganol #{idx}"
p all_diaganols[idx]
values = get_diaganol_values(all_diaganols[idx])
p values
puts max_count(values, 'x') == 4

idx = 17
puts "diaganol #{idx}"
p all_diaganols[idx]
values = get_diaganol_values(all_diaganols[idx])
p values
puts max_count(values, 'x') == 4
