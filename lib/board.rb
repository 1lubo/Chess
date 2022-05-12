# frozen_string_literal: true

require 'json'
require_relative './colors.rb'
require_relative './pieces.rb'

class Board
  attr_accessor :board, :captured_pieces

  SYMBOLS = { 'b' => { 'king' => "\u{2654}", 'queen' => "\u{2655}", 'rook' => "\u{2656}", 'bishop' => "\u{2657}", 'knight' => "\u{2658}",
                       'pawn' => "\u{2659}" },
              'w' => { 'king' => "\u{265A}", 'queen' => "\u{265B}", 'rook' => "\u{265C}", 'bishop' => "\u{265D}", 'knight' => "\u{265E}",
                       'pawn' => "\u{265F}" } }.freeze

  PM = "\u{2727}" # symbol for possible moves

  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
    @captured_pieces = []
  end

  def to_json(*_args)
    {
      'pieces' => @board.flatten.compact,
      'captured_pieces' => @captured_pieces

    }.to_json
  end

  def draw_board
    board.each_with_index do |row, index|
      index.even? ? (puts "#{index + 1} #{draw_even_row(row)}") : (puts "#{index + 1} #{draw_odd_row(row)}")
    end
    puts draw_letters_row
  end

  def reset_board
    @board = Array.new(8) { Array.new(8, nil) }
    @captured_pieces = []
    populate_black
    populate_white
  end

  def draw_even_row(array_row)
    row_string = ''
    array_row.each_with_index do |item, index|
      if index.even?
        if item.nil?
          row_string += ' ' + ' '.blue
        elsif item.class != String
          item.highlight ? row_string += " #{item.to_s.highlight}" : row_string += " #{item.to_s.blue}"
        else
          row_string += " #{item.to_s.blue}"
        end
      else
        if item.nil?
          row_string += ' ' + ' '.black
        elsif item.class != String
          item.highlight ? row_string += " #{item.to_s.highlight}" : row_string += " #{item.to_s.black}"
        else
          row_string += " #{item.to_s.black}"
        end
      end
    end
    row_string += "\n"
  end

  def draw_odd_row(array_row)
    row_string = ''
    array_row.each_with_index do |item, index|
      if index.even?
        if item.nil?
          row_string += ' ' + ' '.black
        elsif item.class != String
          item.highlight ? row_string += " #{item.to_s.highlight}" : row_string += " #{item.to_s.black}"
        else
          row_string += " #{item.to_s.black}"
        end
      else
        if item.nil?
          row_string += ' ' + ' '.blue
        elsif item.class != String
          item.highlight ? row_string += " #{item.to_s.highlight}" : row_string += " #{item.to_s.blue}"
        else
          row_string += " #{item.to_s.blue}"
        end
      end
    end
    row_string += "\n"
  end

  def draw_letters_row
    row_string = '  '

    8.times do |i|
      row_string += ' ' + (97 + i).chr.to_s
    end

    row_string
  end

  def populate_white
    board[7][0] = Rook.new('white', [7, 0], board)
    board[7][7] = Rook.new('white', [7, 7], board)
    board[7][1] = Knight.new('white', [7, 1], board)
    board[7][6] = Knight.new('white', [7, 6], board)
    board[7][2] = Bishop.new('white', [7, 2], board)
    board[7][5] = Bishop.new('white', [7, 5], board)
    board[7][3] = Queen.new('white', [7, 3], board)
    board[7][4] = King.new('white', [7, 4], board)

    (1..8).each do |i|
      board[6][i - 1] = Pawn.new('white', [6, i - 1], board)
    end
  end

  def populate_black
    board[0][0] = Rook.new('black', [0, 0], board)
    board[0][7] = Rook.new('black', [0, 7], board)
    board[0][1] = Knight.new('black', [0, 1], board)
    board[0][6] = Knight.new('black', [0, 6], board)
    board[0][2] = Bishop.new('black', [0, 2], board)
    board[0][5] = Bishop.new('black', [0, 5], board)
    board[0][3] = Queen.new('black', [0, 3], board)
    board[0][4] = King.new('black', [0, 4], board)

    (1..8).each do |i|
      board[1][i - 1] = Pawn.new('black', [1, i - 1], board)
    end
  end

  def move_piece(piece, target)
    starting_square = piece.position

    target_square = board[target[0]][target[1]]

    captured_pieces << target_square unless target_square.nil?

    board[target[0]][target[1]] = piece
    piece.position = [target[0], target[1]]
    piece.num_moves += 1
    board[starting_square[0]][starting_square[1]] = nil
  end

  def add_possible_moves(piece)
    piece.possible_moves.each do |move|
      if board[move[0]][move[1]].nil?
        board[move[0]][move[1]] = PM

      else
        board[move[0]][move[1]].highlight = true
      end
    end
  end

  def remove_possible_moves(piece)
    piece.possible_moves.each do |move|
      if board[move[0]][move[1]] == PM
        board[move[0]][move[1]] = nil
      elsif !board[move[0]][move[1]].nil?
        board[move[0]][move[1]].highlight = false
      end
    end
  end

  def populate_board_from_save(pieces)
    pieces.each do |piece|
      clazz = Object.const_get(piece['type'])
      color = piece['color']
      position = piece['position']
      clazz.new(color, position, board)
    end
  end
end
