require_relative './pieces.rb'
require_relative './board.rb'

    '''
    def moving_north?(starts, ends)
        starts[0] > ends[0] && starts[1] == ends[1]
    end
    
    def moving_northwest?(starts, ends)
        starts[0] > ends[0] && starts[1] < ends[1]
    end
    
    def moving_west?(starts, ends)
        starts[0] == ends[0] && starts[1] < ends[1]
    end
    
    def moving_southwest?(starts, ends)
        starts[0] < ends[0] && starts[1] < ends[1]
    end
    
    def moving_south?(starts, ends)
        starts[0] < ends[0] && starts[1] == ends[1]
    end
    
    def moving_southeast?(starts, ends)
        starts[0] < ends[0] && starts[1] > ends[1]
    end
    
    def moving_east?(starts, ends)
        starts[0] == ends[0] && starts[1] > ends[1]
    end
    
    def moving_northeast?(starts, ends)
        starts[0] > ends[0] && starts[1] > ends[1]
    end
    
    def line_north_clear?(starts, ends)
        line_north = []
        sqaure_coordinates_between_here_and_there = []
        (1..(starts[0] - ends[0]) - 1).each do |i|
            line_north << Board[starts[0] - i][ends[1]]
            sqaure_coordinates_between_here_and_there << [starts[0] - i, ends[1]]
        end
        puts "Between start and end there is: #{sqaure_coordinates_between_here_and_there}"
        return line_north.uniq.length == 1 && line_north.uniq[0].nil?
    
    end
    
    def line_northwest_clear?(starts, ends)
        line_northwest = []
        sqaure_coordinates_between_here_and_there = []    
        (1..(starts[0] - ends[0]) - 1).each do |i|
            line_northwest << Board[starts[0] - i][starts[1] + i]
            sqaure_coordinates_between_here_and_there << [starts[0] - i, starts[1] + i]
        end
        puts "Between start and end there is: #{sqaure_coordinates_between_here_and_there}"
    
        return line_northwest.uniq.length == 1 && line_northwest.uniq[0].nil?
    
    end
    
    def line_west_clear?(starts, ends)
        line_west = []
        sqaure_coordinates_between_here_and_there = []
        (1..(ends[1] - starts[1] - 1)).each do |i|
            line_west << Board[ends[0]][starts[1] + i]
            sqaure_coordinates_between_here_and_there << [ends[0], starts[1] + i]
        end
        puts "Between start and end there is: #{sqaure_coordinates_between_here_and_there}"
        return line_west.uniq.length == 1 && line_west.uniq[0].nil?
    end
    
    def line_southwest_clear?(starts, ends)
        line_southwest = []
        sqaure_coordinates_between_here_and_there = []
        (1..(ends[1] - starts[1] - 1)).each do |i|
            line_southwest << Board[starts[0] + i][starts[1] + i]
            sqaure_coordinates_between_here_and_there << [starts[0]+i, starts[1]+i]
        end
        puts "Between start and end there is: #{sqaure_coordinates_between_here_and_there}"
        return line_southwest.uniq.length == 1 && line_southwest.uniq[0].nil?
    end
    
    def line_south_clear?(starts, ends)
        line_south = []
        sqaure_coordinates_between_here_and_there = []
        (1..(ends[0] - starts[0] - 1)).each do |i|
            line_south << Board[starts[0] + i][starts[1]]
            sqaure_coordinates_between_here_and_there << [starts[0]+i, starts[1]]
            
        end
        puts "Between start and end there is: #{sqaure_coordinates_between_here_and_there}"
    
        return line_south.uniq.length == 1 && line_south.uniq[0].nil?
    end
    
    def line_southeast_clear?(starts, ends)
        line_southeast = []
        sqaure_coordinates_between_here_and_there = []
        (1..(starts[1] - ends[1] - 1)).each do |i|        
            line_southeast << Board[starts[0] + i][starts[1] - i]
            sqaure_coordinates_between_here_and_there << [starts[0]+i, starts[1] - i]
        end
        puts "Between start and end there is: #{sqaure_coordinates_between_here_and_there}"
        return line_southeast.uniq.length == 1 && line_southeast.uniq[0].nil?
    end
    
    def line_east_clear?(starts, ends)
        line_east = []
        sqaure_coordinates_between_here_and_there = []
        (1..(starts[1] - ends[1] - 1)).each do |i|
            
            line_east << Board[starts[0]][starts[1] - i]
            sqaure_coordinates_between_here_and_there << [starts[0], starts[1] - i]
        end
        puts "Between start and end there is: #{sqaure_coordinates_between_here_and_there}"
        return line_east.uniq.length == 1 && line_east.uniq[0].nil?
    end
    
    def line_northeast_clear?(starts, ends)
        line_northeast = []
        sqaure_coordinates_between_here_and_there = []
        (1..(starts[0] - ends[0] - 1)).each do |i|
            line_northeast << Board[starts[0] - 1][starts[1] - 1]
            sqaure_coordinates_between_here_and_there << [starts[0] - i, starts[1] - i]
        end
        puts "Between start and end there is: #{sqaure_coordinates_between_here_and_there}"
        return line_northeast.uniq.length == 1 && line_northeast.uniq[0].nil?
    end
    
    board_current = [7, 6]
    board_target = [2, 6]
    
    #puts "It is #{moving_north?(board_current, board_target)} that the target is East from the start"
#puts "It is #{line_north_clear?(board_current, board_target)} that the line to the target is clear."
'''

#puts [1,2,3,4,5,6,7,8].filter { |i| i % 2 ==0}.filter { |i| i % 3 == 0}

br = Board.new


br.board[6][3] = nil
wr = br.board[7][0]
wrmoves = wr.possible_moves

puts br.board[6][0]
puts "#{wrmoves}"


