
class Piece
    
    attr_accessor :color, :type, :position, :possible_moves, :legal_moves, :num_moves, :board 

    Symbols = { 'b' => {"king" => "\u{2654}", "queen" => "\u{2655}", "rook" => "\u{2656}", "bishop" => "\u{2657}", "knight" => "\u{2658}",
    "pawn" => "\u{2659}"}, 
    'w' =>  {"king" => "\u{265A}", "queen" => "\u{265B}", "rook" => "\u{265C}", "bishop" => "\u{265D}", "knight" => "\u{265E}",
    "pawn" => "\u{265F}"} }  

    Legal_moves = nil
    
    def initialize(player_color, coordinates, board)
        @board = board
        @color = player_color        
        @position = coordinates
        @possible_moves = get_possible_moves(self.class::Legal_moves)
        @num_moves = 0

    end

    def to_s
        Symbols["#{color[0]}"]["#{type}"]
    end



    def not_out_of_bounds(coordinates)
        
        return false if (coordinates[0] < 0 || coordinates[1] < 0) || (coordinates[0] > 7 || coordinates[1] > 7)

        true
    end    

    def get_possible_moves(legal_moves_array)
        
        next_moves = []        
        legal_moves_array.each { |jump| next_moves << [jump[0] + position[0], jump[1] + position[1]] }
        
        return next_moves.filter { |move| not_out_of_bounds(move) }.filter { |move| validate_moves_filter(move)}
        
    end
    

    def validate_moves_filter(target)
        
        target_square = board[target[0]][target[1]]
                
        #return false if possible_moves.include?(target) == false 
        #is target in list of possible moves. Return -1 if not.
        
        return false if !target_square.nil? && target_square.color == color 
        #is target occupied by piece of the same color. Return -2 if yes.
        
        
        
        
        case where_to?(target)
            #check the line in the direction of movement. Return -3 if line not empty.
        when 'N'            
            return true if line_north_clear?(target)
            return false

        when  'NW'            
            return true if line_northwest_clear?(target)
            return false

        when 'W'            
            return true if line_west_clear?(target)
            return false

        when 'SW'            
            return true if line_southwest_clear?(target)
            return false

        when 'S'            
            return true if line_south_clear?(target)
            return false

        when 'SE'            
            return true if line_southeast_clear?(target)
            return false

        when 'E'            
            return true if line_east_clear?(target)
            return false

        when 'NE'            
            return true if line_northeast_clear?(target)
            return false

        else 
            return false
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

        return true if (position[0] - target[0] - 1) == 0
                
        line_north = []
        (1..(position[0] - target[0] - 1)).each do |i|            
            line_north << board[position[0] - i][target[1]]
        end

        return line_north.uniq.length == 1 && line_north.uniq[0].nil?

    end

    def line_northwest_clear?(target)

        return true if (position[0] - target[0] - 1) == 0 &&
        (target[1] - position[1] - 1) == 0

        line_northwest = []
        (1..(position[0] - target[0] -1)).each do |i|
            line_northwest << board[position[0] - i][position[1] + i]
        end

        return line_northwest.uniq.length == 1 && line_northwest.uniq[0].nil?

    end

    def line_west_clear?(target)

        return true if (target[1] - position[1] - 1) == 0

        line_west = []
        (1..(target[1] - position[1] - 1)).each do |i|
            line_west << board[target[0]][position[1] + i]
        end

        return line_west.uniq.length == 1 && line_west.uniq[0].nil?
    end

    def line_southwest_clear?(target)

        return true if (target[0] - position[0] - 1) == 0 &&
        (target[1] - position[1] - 1) == 0

        line_southwest = []
        (1..(target[1] - position[1] - 1)).each do |i|
            line_southwest << board[position[0] + i][position[1] + i]
        end

        return line_southwest.uniq.length == 1 && line_southwest.uniq[0].nil?
    end

    def line_south_clear?(target)

        return true if (target[0] - position[0] - 1) == 0

        line_south = []
        (1..(target[0] - position[0] - 1)).each do |i|
            line_south << board[position[0] + i][position[1]]
        end

        return line_south.uniq.length == 1 && line_south.uniq[0].nil?
    end

    def line_southeast_clear?(target)

        return true if (target[0] - position[0] - 1) == 0 &&
        (position[1] - target[1] - 1) == 0

        line_southeast = []
        (1..(position[1] - target[1] - 1)).each do |i|
            line_southeast << board[position[0] + i][position[1] - i]
        end

        return line_southeast.uniq.length == 1 && line_southeast.uniq[0].nil?
    end

    def line_east_clear?(target)

        return true if (position[1] - target[1] - 1) == 0

        line_east = []
        (1..(position[1] - target[1] - 1)).each do |i|
            line_east << board[position[0]][position[1] - i]
        end

        return line_east.uniq.length == 1 && line_east.uniq[0].nil?
    end

    def line_northeast_clear?(target)

        return true if (position[0] - target[0] - 1) == 0 &&
        (position[1] - target[1] - 1) == 0

        line_northeast = []
        (1..(position[0] - target[0] - 1)).each do |i|
            line_northeast << board[position[0] - 1][position[1] - 1]
        end

        return line_northeast.uniq.length == 1 && line_northeast.uniq[0].nil?
    end

    def where_to?(target)
        moving_north?(target) || moving_northwest?(target) || moving_west?(target) ||
        moving_southwest?(target) || moving_south?(target) || moving_southeast?(target) ||
        moving_east?(target) || moving_northeast?(target)
    end


    



end

class King < Piece
    attr_accessor :num_moves

    Legal_moves = [[0, -1], [-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1]]

    def initialize(player_color, coordinates, board)
        super

        @type = 'king'
              
        
    end

    def refresh_possible_moves
        next_moves = []        
        Legal_moves.each { |jump| next_moves << [jump[0] + position[0], jump[1] + position[1]] }
        
        @possible_moves = next_moves.filter { |move| not_out_of_bounds(move) }
    end

end

class Queen < Piece


    Legal_moves = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                    [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0],
                    [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                    [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7],
                    [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
                    [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                    [1, -1], [2, -2], [3, -3], [4, -4], [5, 5], [6, 6], [7, -7],
                    [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7]]

    def initialize(player_color, coordinates, board)
        super

        @type = 'queen'
    end

    def refresh_possible_moves
        next_moves = []        
        Legal_moves.each { |jump| next_moves << [jump[0] + position[0], jump[1] + position[1]] }
        
        @possible_moves = next_moves.filter { |move| not_out_of_bounds(move) }
    end
    
end

class Rook < Piece

    attr_accessor :num_moves

    Legal_moves = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                    [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0],
                [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7]]

    def initialize(player_color, coordinates, board)
        super

        @type = 'rook'
        
    end

    def refresh_possible_moves
        next_moves = []        
        Legal_moves.each { |jump| next_moves << [jump[0] + position[0], jump[1] + position[1]] }
        
        @possible_moves = next_moves.filter { |move| not_out_of_bounds(move) }
    end

end

class Bishop < Piece

    Legal_moves = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
    [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
    [1, -1], [2, -2], [3, -3], [4, -4], [5, 5], [6, 6], [7, -7],
    [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7]]

    def initialize(player_color, coordinates, board)
        super

        @type = 'bishop'
    end

    def refresh_possible_moves
        next_moves = []        
        Legal_moves.each { |jump| next_moves << [jump[0] + position[0], jump[1] + position[1]] }
        
        @possible_moves = next_moves.filter { |move| not_out_of_bounds(move) }
    end
end

class Knight < Piece

    Legal_moves = [[2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, 2]]

    def initialize(player_color, coordinates, board)
        super

        @type = 'knight'
    end

    def refresh_possible_moves
        next_moves = []        
        Legal_moves.each { |jump| next_moves << [jump[0] + position[0], jump[1] + position[1]] }
        
        @possible_moves = next_moves.filter { |move| not_out_of_bounds(move) }
    end

    def validate_move(target) 
                
        target_square = @board.board[target[0]][target[1]]
                
        return -1 if possible_moves.include?(target) == false 
        #is target in list of possible moves. Return -1 if not.
        
        return -2 if !target_square.nil? && target_square.color == color 
        #is target occupied by piece of the same color. Return -2 if yes.

        # Knight can leap over other pieces. No other validation necessary.
    end

    
end

class Pawn < Piece
    attr_accessor :num_moves   

    def initialize(player_color, coordinates, board)  
        @board = board      
        @color = player_color        
        @position = coordinates
        @type = 'pawn'        
        #@possible_moves = get_possible_moves
        @num_moves = 0

    end

    #def get_possible_moves
    #    
    #    next_moves = []   
#
    #    if color == 'white' && num_moves == 0 
    #        next_moves << [position[0] -1 , position[1]]
    #        next_moves << [position[0] -2 , position[1]]
#
    #    elsif color == 'white' && num_moves > 0
    #        next_moves << [position[0] -1 , position[1]]
#
    #    elsif color == 'black' && num_moves == 0
    #        next_moves << [position[0] +1 , position[1]]
    #        next_moves << [position[0] +2 , position[1]]
#
    #    elsif color == 'black' && num_moves > 0
    #        next_moves << [position[0] +1 , position[1]]
    #    end
#
    #    return next_moves.filter { |move| not_out_of_bounds(move) }
    #    
    #end

    def refresh_possible_moves
        
        next_moves = []   

        color == 'white' ? next_moves << [position[0] -1 , position[1]] : next_moves << [position[0] +1 , position[1]]
       
        @possible_moves = next_moves.filter { |move| not_out_of_bounds(move) }
    end


end


