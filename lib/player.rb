require_relative './board.rb'

class Player

    attr_accessor :number

    def initialize(number, board)
        @name = name
        @number = number    
        @board = board    
    end

    def player_input()
        loop do
          user_input = gets.chomp          
            if user_input.match?(/^[a-h]{1}[1-8]{1}$/)
                column_empty = board.check_column(user_input.to_i)
                if column_empty
                    return user_input.to_i                
                else
                    puts "Column us full. Please make another choice."
                end
            else
                puts "Input error! Please enter a number between 1 and 7."
            end
        end
    end    

end
