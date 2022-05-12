# frozen_string_literal: true

require 'json'
require_relative './pieces.rb'
require_relative './board.rb'
require_relative './player.rb'

BOLDS = "\e[1m" # bold start
BOLDE = "\e[22m" # bold end

# this is where the magic happens
class Game
  SAVE_FOLDER_NAME = './saves/'
  SAVE_NAME = 'save.txt'
  attr_accessor :game_board, :white, :black, :players, :interrupt_game, :players_turn
  def initialize
    @game_board = Board.new
    game_board.populate_black
    game_board.populate_white
    @white = Player.new('white', game_board)
    @black = Player.new('black', game_board)
    @interrupt_game = white.interrupt || black.interrupt
    @players_turn = 'white'
    @players = { 'white' => white, 'black' => black }
  end

  def player_move(player)
    puts "It is #{player.color}'s move!"
    piece = player.get_piece
    return if %w[q s].include?(piece)

    game_board.add_possible_moves(piece)
    puts `clear`
    game_board.draw_board
    puts "It is #{player.color}'s move!"
    target_square = player.get_target(piece)
    return if %w[q s].include?(target_square)

    game_board.remove_possible_moves(piece)
    game_board.move_piece(piece, target_square)
    puts `clear`
    game_board.draw_board
  end

  def start_game
    want_to_play = ''
    acceptable_answers = %w[yes no load]
    puts 'Would you like to play a game of chess?'
    puts "Please answer: \n'yes' - to start a new game \n'load' - to load a saved game \n'no' - to quit"

    until acceptable_answers.include?(want_to_play)
      puts 'Please choose one of the above options'
      want_to_play = gets.chomp.downcase
    end

    want_to_play
  end

  def play
    puts `clear`
    start = start_game
    puts `clear`
    return if start == 'no'

    if start == 'load'
      saved_game = load_game
      @game_board = Board.new
      game_board.populate_board_from_save(saved_game['board']['pieces'])
      @players_turn = saved_game['players_turn']
    end

    game_board.draw_board
    loop do
      player_move(players[players_turn])
      current = players_turn
      @players_turn = current == 'white' ? 'black' : 'white'
      @interrupt_game = white.interrupt || black.interrupt
      break if interrupt_game
    end

    if interrupt_game == 's'
      puts 'Saving game'
      sleep(1)
      save_game
      sleep(2)
      puts 'game end'
    else
      puts 'game end'
    end
    nil
  end

  def to_json(*_args)
    { 'board' => @game_board,
      'players_turn' => @players_turn }.to_json
  end

  def save_game
    if Dir.exist?(SAVE_FOLDER_NAME)
      puts 'Save folder already exists. Saving file'
    else
      puts 'Save folder does not exist'
      puts 'Creating save folder'
      Dir.mkdir(SAVE_FOLDER_NAME)
    end
    game_in_json = to_json
    # File.open("#{SAVE_FOLDER_NAME}#{SAVE_NAME}", 'w') { |somefile| somefile.write game_in_json }
    File.write("#{SAVE_FOLDER_NAME}#{SAVE_NAME}", game_in_json)
  end

  def deserialize(saved_game)
    JSON.parse(saved_game)
  end

  def load_game
    if File.exist?("#{SAVE_FOLDER_NAME}#{SAVE_NAME}")

      contents = File.open("#{SAVE_FOLDER_NAME}#{SAVE_NAME}", 'r', &:read)
      deserialize(contents)
    else
      puts `clear`
      puts "#{BOLDS}No save file exists yet#{BOLDE}"
      puts
      false
    end
  end
end
