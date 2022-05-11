# frozen_string_literal: true

require_relative './board.rb'
require_relative './modules.rb'

class Player
  include NotationTranslation
  attr_accessor :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def get_input(info)
    loop do
      puts info
      user_input = gets.chomp.downcase

      return user_input if user_input.match?(/^[a-h]{1}[1-8]{1}$/)

      puts 'Input error! Please enter a file (a - h) and rank (1 - 8).'
    end
  end

  def get_piece
    info = 'Enter the coordinates of the piece you want to move.'
    selection = nil

    until selection

      input = get_input(info)
      coordinates = notation_to_coordinates(input)
      selection = board.board[coordinates[0]][coordinates[1]]

      if selection.nil? # selected square is empty
        puts 'Selected sqaure is empty.'
        next
      else
        selection.refresh_possible_moves
      end

      if selection.color != color # selected piece is opposite color
        puts 'Selected piece is of opposite color.'
        selection = nil
        next
      end

      if selection.possible_moves.empty?
        puts 'This piece does not have any valid moves.'
        selection = nil
        next
      else
        selection.refresh_possible_moves
      end
    end

    selection
  end

  def get_target(piece)
    info = 'Enter target coordinates'
    target = nil

    until target
      input = get_input(info)
      target = notation_to_coordinates(input)

      if !piece.possible_moves.include?(target)
        puts 'Invalid coordinates.'
        target = nil
        next
      else
        return target
      end
    end
  end
end
