require_relative './colors.rb'
require_relative './pieces.rb'

class Board

    attr_accessor :board, :captured_pieces

    Symbols = { 'b' => {"king" => "\u{2654}", "queen" => "\u{2655}", "rook" => "\u{2656}", "bishop" => "\u{2657}", "knight" => "\u{2658}",
    "pawn" => "\u{2659}"}, 
    'w' =>  {"king" => "\u{265A}", "queen" => "\u{265B}", "rook" => "\u{265C}", "bishop" => "\u{265D}", "knight" => "\u{265E}",
    "pawn" => "\u{265F}"} }      

    

    def initialize
        @board = Array.new(8) {Array.new(8, nil)}
        populate_black
        populate_white
        @captured_pieces = []
    end

    def draw_board
        board.each_with_index do |row, index|
            index.even? ? (puts "#{index + 1} #{draw_even_row(row)}") : (puts "#{index + 1} #{draw_odd_row(row)}")
        end
        puts draw_letters_row
    end

    def clear_board
        @board = Array.new(8) {Array.new(8, nil)}
        @captured_pieces = []
        populate_black
        populate_white

    end

    def draw_even_row(array_row)
        row_string = ""
        array_row.each_with_index do |item, index|
            if index.even?
                item.nil? ? row_string += " " + " ".blue : row_string += " #{item.to_s.blue}"
            else                
                item.nil? ? row_string += " " + " ".black : row_string += " #{item.to_s.black}"
            end
        end
        return row_string += "\n"
    end

    def draw_odd_row(array_row)
        row_string = ""
        array_row.each_with_index do |item, index|
            if index.even?
                item.nil? ? row_string += " " + " ".black : row_string += " #{item.to_s.black}"
            else                
                item.nil? ? row_string += " " + " ".blue : row_string += " #{item.to_s.blue}"
            end
        end
        return row_string += "\n"
    end

    def draw_letters_row
        row_string = "  "
        
        8.times do |i|
            row_string += " " + "#{(97+i).chr}"
        end

        row_string
    end

    def populate_white
        board[7][0] = Rook.new('white', [7, 0], board)
        board[7][7] = Rook.new('white', [7, 7],board)
        board[7][1] = Knight.new('white', [7, 1], board)
        board[7][6] = Knight.new('white', [7, 6], board)
        board[7][2] = Bishop.new('white', [7, 2], board)
        board[7][5] = Bishop.new('white', [7, 5], board)
        board[7][3] = Queen.new('white', [7, 3], board)
        board[7][4] = King.new('white', [7, 4], board)

        (1..8).each do |i|
            board[6][i-1] = Pawn.new('white', [6, i - 1], board)
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
            board[1][i-1] = Pawn.new('black', [1, i - 1], board)
        end
    end

    def move_piece(piece, target)

        starting_square = piece.position
        target_square = board[target[0]][target[1]] 

        if !target_square.nil?
            captured_pieces << target_square            
        end

        board[target[0]][target[1]] = piece
        piece.position = [target[0], target[1]]
        piece.num_moves += 1
        piece.refresh_possible_moves
        board[starting_square[0]][starting_square[1]] = nil


    end
end

