# frozen_string_literal: true

require 'json'

class Piece
  attr_accessor :color, :type, :position, :possible_moves, :legal_moves, :num_moves, :board, :highlight

  SYMBOLS = { 'b' => { 'king' => "\u{2654}", 'queen' => "\u{2655}",
                       'rook' => "\u{2656}", 'bishop' => "\u{2657}", 'knight' => "\u{2658}",
                       'pawn' => "\u{2659}" },
              'w' => { 'king' => "\u{265A}", 'queen' => "\u{265B}",
                       'rook' => "\u{265C}", 'bishop' => "\u{265D}", 'knight' => "\u{265E}",
                       'pawn' => "\u{265F}" } }.freeze

  LEGAL_MOVES = nil

  def initialize(player_color, coordinates, board)
    @board = board
    @color = player_color
    @position = coordinates
    @num_moves = 0
    @highlight = false
  end

  def to_s
    SYMBOLS[color[0].to_s][type.to_s]
  end

  def to_json(*_args)
    {
      'type' => self.class.name,
      'color' => @color, 'position' => @position, 'num_moves' => @num_moves
    }.to_json
  end

  def not_out_of_bounds(coordinates)
    if (coordinates[0].negative? || coordinates[1].negative?) ||
       (coordinates[0] > 7 || coordinates[1] > 7)
      return false
    end

    true
  end

  def get_possible_moves(legal_moves_array)
    next_moves = []
    legal_moves_array.each { |jump| next_moves << [jump[0] + position[0], jump[1] + position[1]] }
    next_moves.filter! { |move| not_out_of_bounds(move) }

    next_moves.filter { |move| validate_moves_filter(move) }
  end

  def validate_moves_filter(target)
    target_square = board[target[0]][target[1]]

    return false if !target_square.nil? && target_square.color == color

    case where_to?(target)

    when 'N'
      return true if line_north_clear?(target)

    when 'NW'
      return true if line_northwest_clear?(target)

    when 'W'
      return true if line_west_clear?(target)

    when 'SW'
      return true if line_southwest_clear?(target)

    when 'S'
      return true if line_south_clear?(target)

    when 'SE'
      return true if line_southeast_clear?(target)

    when 'E'
      return true if line_east_clear?(target)

    when 'NE'
      return true if line_northeast_clear?(target)

    else
      false
    end
  end

  def moving_north?(target)
    return 'N' if position[0] > target[0] && position[1] == target[1]

    false
  end

  def moving_northwest?(target)
    return 'NW' if position[0] > target[0] && position[1] < target[1]

    false
  end

  def moving_west?(target)
    return 'W' if position[0] == target[0] && position[1] < target[1]

    false
  end

  def moving_southwest?(target)
    return 'SW' if position[0] < target[0] && position[1] < target[1]

    false
  end

  def moving_south?(target)
    return 'S' if position[0] < target[0] && position[1] == target[1]

    false
  end

  def moving_southeast?(target)
    return 'SE' if position[0] < target[0] && position[1] > target[1]

    false
  end

  def moving_east?(target)
    return 'E' if position[0] == target[0] && position[1] > target[1]

    false
  end

  def moving_northeast?(target)
    return 'NE' if position[0] > target[0] && position[1] > target[1]

    false
  end

  def line_north_clear?(target)
    next_to_me = board[position[0] - 1][position[1]]

    if !next_to_me.nil?
      if (position[0] - target[0] - 1).zero? && next_to_me.color != color
        return true
      end

    elsif next_to_me.nil?
      return true if (position[0] - target[0] - 1).zero?
    end

    line_north = []
    (1..(position[0] - target[0] - 1)).each do |i|
      line_north << board[position[0] - i][target[1]]
    end

    line_north.uniq.length == 1 && line_north.uniq[0].nil?
  end

  def line_northwest_clear?(target)
    next_to_me = board[position[0] - 1][position[1] + 1]

    if !next_to_me.nil?
      return true if (position[0] - target[0] - 1).zero? &&
                     (target[1] - position[1] - 1).zero? && next_to_me.color != color
    elsif next_to_me.nil?
      return true if (position[0] - target[0] - 1).zero? &&
                     (target[1] - position[1] - 1).zero?
    end

    line_northwest = []
    (1..(position[0] - target[0] - 1)).each do |i|
      line_northwest << board[position[0] - i][position[1] + i]
    end

    line_northwest.uniq.length == 1 && line_northwest.uniq[0].nil?
  end

  def line_west_clear?(target)
    next_to_me = board[position[0]][position[1] + 1]

    if !next_to_me.nil?
      if (target[1] - position[1] - 1).zero? && next_to_me.color != color
        return true
      end
    elsif next_to_me.nil?
      return true if (target[1] - position[1] - 1).zero?
    end

    line_west = []
    (1..(target[1] - position[1] - 1)).each do |i|
      line_west << board[target[0]][position[1] + i]
    end

    line_west.uniq.length == 1 && line_west.uniq[0].nil?
  end

  def line_southwest_clear?(target)
    next_to_me = board[position[0] + 1][position[1] + 1]

    if !next_to_me.nil?
      return true if (target[0] - position[0] - 1).zero? &&
                     (target[1] - position[1] - 1).zero? && next_to_me.color != color
    elsif next_to_me.nil?
      return true if (target[0] - position[0] - 1).zero? &&
                     (target[1] - position[1] - 1).zero?
    end

    line_southwest = []
    (1..(target[1] - position[1] - 1)).each do |i|
      line_southwest << board[position[0] + i][position[1] + i]
    end

    line_southwest.uniq.length == 1 && line_southwest.uniq[0].nil?
  end

  def line_south_clear?(target)
    next_to_me = board[position[0] + 1][position[1]]

    if !next_to_me.nil?
      if (target[0] - position[0] - 1).zero? && next_to_me.color != color
        return true
      end
    elsif next_to_me.nil?
      return true if (target[0] - position[0] - 1).zero?
    end

    line_south = []
    (1..(target[0] - position[0] - 1)).each do |i|
      line_south << board[position[0] + i][position[1]]
    end

    line_south.uniq.length == 1 && line_south.uniq[0].nil?
  end

  def line_southeast_clear?(target)
    next_to_me = board[position[0] + 1][position[1] - 1]

    if !next_to_me.nil?
      return true if (target[0] - position[0] - 1).zero? &&
                     (position[1] - target[1] - 1).zero? && next_to_me.color != color
    elsif next_to_me.nil?
      return true if (target[0] - position[0] - 1).zero? &&
                     (position[1] - target[1] - 1).zero?
    end

    line_southeast = []
    (1..(position[1] - target[1] - 1)).each do |i|
      line_southeast << board[position[0] + i][position[1] - i]
    end

    line_southeast.uniq.length == 1 && line_southeast.uniq[0].nil?
  end

  def line_east_clear?(target)
    next_to_me = board[position[0]][position[1] - 1]

    if !next_to_me.nil?
      if (position[1] - target[1] - 1).zero? && next_to_me.color != color
        return true
      end

    elsif next_to_me.nil?
      return true if (position[1] - target[1] - 1).zero?
    end

    line_east = []
    (1..(position[1] - target[1] - 1)).each do |i|
      line_east << board[position[0]][position[1] - i]
    end

    line_east.uniq.length == 1 && line_east.uniq[0].nil?
  end

  def line_northeast_clear?(target)
    next_to_me = board[position[0] - 1][position[1] - 1]

    if !next_to_me.nil?
      return true if (position[0] - target[0] - 1).zero? &&
                     (position[1] - target[1] - 1).zero? && next_to_me.color != color
    elsif next_to_me.nil?
      return true if (position[0] - target[0] - 1).zero? &&
                     (position[1] - target[1] - 1).zero?
    end

    line_northeast = []
    (1..(position[0] - target[0] - 1)).each do |_i|
      line_northeast << board[position[0] - 1][position[1] - 1]
    end

    line_northeast.uniq.length == 1 && line_northeast.uniq[0].nil?
  end

  def where_to?(target)
    moving_north?(target) || moving_northwest?(target) || moving_west?(target) ||
      moving_southwest?(target) || moving_south?(target) || moving_southeast?(target) ||
      moving_east?(target) || moving_northeast?(target)
  end
end

# sub-class for the King piece
class King < Piece
  attr_accessor :color, :type, :position, :possible_moves, :LEGAL_MOVES, :num_moves, :board

  LEGAL_MOVES = [[0, -1], [-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1]].freeze

  def initialize(player_color, coordinates, board)
    super(player_color, coordinates, board)
    board[coordinates[0]][coordinates[1]] = self
    @type = 'king'
    @possible_moves = nil
  end

  def refresh_possible_moves
    next_moves = []
    LEGAL_MOVES.each { |jump| next_moves << [jump[0] + position[0], jump[1] + position[1]] }
    @possible_moves = next_moves.filter { |move| not_out_of_bounds(move) }.filter { |move| validate_moves_filter(move) }
  end

  def castling
    # to-do method for castling
  end
end

# sub-class for the Queen piece
class Queen < Piece
  attr_accessor :color, :type, :position, :possible_moves, :legal_moves, :num_moves, :board

  LEGAL_MOVES = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                 [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0],
                 [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                 [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7],
                 [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
                 [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                 [1, -1], [2, -2], [3, -3], [4, -4], [5, 5], [6, 6], [7, -7],
                 [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7]].freeze

  def initialize(player_color, coordinates, board)
    super(player_color, coordinates, board)

    board[coordinates[0]][coordinates[1]] = self
    @type = 'queen'
    @possible_moves = nil
  end

  def refresh_possible_moves
    next_moves = []
    LEGAL_MOVES.each { |jump| next_moves << [jump[0] + position[0], jump[1] + position[1]] }
    @possible_moves = next_moves.filter { |move| not_out_of_bounds(move) }.filter { |move| validate_moves_filter(move) }
  end
end

# sub-class for the Rook piece
class Rook < Piece
  attr_accessor :color, :type, :position, :possible_moves, :legal_moves, :num_moves, :board

  LEGAL_MOVES = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                 [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0],
                 [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                 [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7]].freeze

  def initialize(player_color, coordinates, board)
    super(player_color, coordinates, board)
    board[coordinates[0]][coordinates[1]] = self

    @type = 'rook'
    @possible_moves = nil
  end

  def refresh_possible_moves
    next_moves = []
    LEGAL_MOVES.each { |jump| next_moves << [jump[0] + position[0], jump[1] + position[1]] }
    @possible_moves = next_moves.filter { |move| not_out_of_bounds(move) }.filter { |move| validate_moves_filter(move) }
  end
end

# sub-class for the Bishop piece
class Bishop < Piece
  attr_accessor :color, :type, :position, :possible_moves, :legal_moves, :num_moves, :board

  LEGAL_MOVES = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
                 [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                 [1, -1], [2, -2], [3, -3], [4, -4], [5, 5], [6, 6], [7, -7],
                 [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7]].freeze

  def initialize(player_color, coordinates, board)
    super(player_color, coordinates, board)
    board[coordinates[0]][coordinates[1]] = self
    @type = 'bishop'
    @possible_moves = nil
  end

  def refresh_possible_moves
    next_moves = []
    LEGAL_MOVES.each { |jump| next_moves << [jump[0] + position[0], jump[1] + position[1]] }
    @possible_moves = next_moves.filter { |move| not_out_of_bounds(move) }.filter { |move| validate_moves_filter(move) }
  end
end

# sub-class for the Knight piece
class Knight < Piece
  attr_accessor :color, :type, :position, :possible_moves, :legal_moves, :num_moves, :board

  LEGAL_MOVES = [[2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, 2]].freeze

  def initialize(player_color, coordinates, board)
    super(player_color, coordinates, board)
    board[coordinates[0]][coordinates[1]] = self
    @type = 'knight'
    @possible_moves = nil
  end

  def refresh_possible_moves
    next_moves = []
    LEGAL_MOVES.each { |jump| next_moves << [jump[0] + position[0], jump[1] + position[1]] }
    @possible_moves = next_moves.filter { |move| not_out_of_bounds(move) }
    @possible_moves = next_moves.filter { |move| validate_moves_filter(move) }
  end

  def validate_moves_filter(target)
    # target_square = board[target[0]][target[1]]

    return false if possible_moves.include?(target) == false
    # is target in list of possible moves. Return -1 if not.

    if !board[target[0]][target[1]].nil? && board[target[0]][target[1]].color == color
      return false
    end

    true
    # Knight can leap over other pieces. No other validation necessary.
  end
end

# sub-class for the Pawn piece
class Pawn < Piece
  attr_accessor :color, :type, :position, :possible_moves, :legal_moves, :num_moves, :board

  def initialize(player_color, coordinates, board)
    @board = board
    @color = player_color
    @position = coordinates
    board[coordinates[0]][coordinates[1]] = self
    @type = 'pawn'
    @possible_moves = nil
    @num_moves = 0
  end

  def refresh_possible_moves
    next_moves = []

    if color == 'white' && num_moves.zero?
      next_moves << [position[0] - 1, position[1]]
      next_moves << [position[0] - 2, position[1]]
      if !board[position[0] - 1][position[1] - 1].nil? &&
         board[position[0] - 1][position[1] - 1].color != color
        next_moves << [position[0] - 1, position[1] - 1]
      elsif !board[position[0] - 1][position[1] + 1].nil? &&
            board[position[0] - 1][position[1] + 1].color != color
        next_moves << [position[0] - 1, position[1] + 1]
      end

    elsif color == 'white' && num_moves.positive?
      next_moves << [position[0] - 1, position[1]]

      if !board[position[0] - 1][position[1] - 1].nil? &&
         board[position[0] - 1][position[1] - 1].color != color
        next_moves << [position[0] - 1, position[1] - 1]
      elsif !board[position[0] - 1][position[1] + 1].nil? &&
            board[position[0] - 1][position[1] + 1].color != color
        next_moves << [position[0] - 1, position[1] + 1]
      end

    elsif color == 'black' && num_moves.zero?
      next_moves << [position[0] + 1, position[1]]
      next_moves << [position[0] + 2, position[1]]

      if !board[position[0] + 1][position[1] - 1].nil? &&
         board[position[0] + 1][position[1] - 1].color != color
        next_moves << [position[0] + 1, position[1] - 1]
      elsif !board[position[0] + 1][position[1] + 1].nil? &&
            board[position[0] + 1][position[1] + 1].color != color
        next_moves << [position[0] + 1, position[1] + 1]
      end

    elsif color == 'black' && num_moves.positive?
      next_moves << [position[0] + 1, position[1]]

      if !board[position[0] + 1][position[1] - 1].nil? &&
         board[position[0] + 1][position[1] - 1].color != color
        next_moves << [position[0] + 1, position[1] - 1]
      elsif !board[position[0] + 1][position[1] + 1].nil? &&
            board[position[0] + 1][position[1] + 1].color != color
        next_moves << [position[0] + 1, position[1] + 1]
      end
    end

    @possible_moves = next_moves.filter { |move| not_out_of_bounds(move) }
  end
end
