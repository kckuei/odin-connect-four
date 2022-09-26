require_relative './board'

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