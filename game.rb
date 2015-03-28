# STRETCH: allow for undo
# Stretch: allow for forfeit/end game if user types "forfeit"/"quit"
# TODO: refactor: turn message passing variable assignment/method calling/argument names.2

# require "byebug"
require_relative "Board.rb"

class Game
  attr_reader :board, :players
  def initialize(board = Board.new, view = View.new)
    @board = board
    @view = view
    @players = ["white", "black"]
    # col in the sense of display
    @col_hash = {
      "a" => 0,
      "b" => 1,
      "c" => 2,
      "d" => 3,
      "e" => 4,
      "f" => 5,
      "g" => 6,
      "h" => 7
    }
  end

  def play
    # stalemate, king capture, and checkmate should fire game_over
    while !game_over?
      players.each do |player|
        # clear screen
        puts "\e[H\e[2J"
        puts display_board
        turn(player)
      end
    end
    # end
  end

  # TODO: refactor this mess.
  def turn(player)
    # "players turn"
    @view.turn_message(player)
    # player, move which piece?
    begin
      # until user gives a input that matches a piece of their color, keep asking.
      @view.choose_piece(player)
    end until valid_pick?(@view.choice, player)
    # choose piece
    piece = @board.find_piece(input_to_coord(@view.choice))
    # find valid moves
    moves = coord_to_string(@board.valid_move(piece))
    # display valid moves and ask player for choice
    @view.display_valid_moves(player, piece.name, moves)
    # player picks a move
    begin
      # player picks a move
      player_choice = @view.pick_move(player, @view.choice)
    end until valid_player_choice?(player_choice, moves)

    # check for piece capture
    if @board.piece_captured?(piece, input_to_coord(player_choice))
      @board.capture_piece(input_to_coord(player_choice))
      @view.display_capture_move(player, player, piece, captured_piece, choice, move_move)
      @board.move(piece, input_to_coord(player_choice))
    else
      @board.move(piece, input_to_coord(player_choice))
    end

    # end turn
    puts "end of turn"
  end

  def valid_player_choice?(player_choice, moves)
    moves.include?(player_choice)
  end

  def valid_pick?(user_input, player)
    coord = input_to_coord(user_input)
    return false if @board.board[coord[0]][coord[0]] == nil
    (@board.board_values.has_key?(user_input) && @board.board[coord[0]][coord[0]].color == player)
    # && (@board[coord[0]][coord[0]].color == player)
    # this needs to check that the square is occupied by a piece of that player
  end

  def input_to_coord(user_input)
    @board.board_values[user_input]
  end

  # turns board coord into player coords
  def coord_to_string(moves)
    moves.map! do |coord|
      coord = @board.board_values.key(coord)
    end
    return moves
  end

  def move_piece(new_pos,piece)
    @board.move(new_pos,piece)
  end

  def display_board
    @board.format
  end

  # checks for king taken, stalemate, or checkmate
  def game_over?
    (king_taken? || stalemate? || checkmate?)
  end

  def king_taken?
    false
  end

  def stalemate?
    false
  end

  def checkmate?
    false
  end

end


class View
  attr_reader :choice

  def turn_message(player)
    message(player_turn_message(player))
  end

  def choose_piece(player)
    message(choose_piece_message(player))
    @choice = user_input
  end

  # pick_move gets sent to game and @move gets sent to "move_piece"
  def pick_move(player, choice)
    message(pick_move_message(player, choice))
    @move = user_input
  end
  # if user picks invalid square
  def pick_again(player)
    message(choose_again_message(player))
    @choice = user_input
  end

  def display_valid_moves(player, piece, moves)
    message(piece_chosen_message(player, piece, moves))
  end

  def display_player_move(player)
    message(player_move_message(player, piece, move))
  end

  def display_capture_move(player)
    message(capture_message)
  end

  def display_game_over(player)
    message(game_over_message(player))
  end

  def display_capture_message(player, player2, piece, captured_piece, choice, move)
    message(capture_message(player, player2, piece, captured_piece, choice, move))
  end

  # Messages to console

  def player_turn_message(player)
    "#{player}'s turn"
  end

  def choose_piece_message(player)
    "#{player}, which piece do you want to move? ex: a5, e8"
  end

  def piece_chosen_message(player, piece, moves)
    "moves for #{player}'s #{piece}" +": " + moves.join(", ")
  end
  # move gets sent to board
  def player_move_message(player, piece, move)
    "ok, #{player}'s #{piece} #{choice} to move to #{move}"
  end

  def pick_move_message(player, choice)
    "#{player}, move #{choice} where?"
  end

  def capture_message(player, player2, piece, captured_piece, choice, move)
    "#{player}'s #{piece} {choice} captures #{player2}'s #{captured_piece} #{move}"
  end

  def choose_again_message(player)
    "#{player}, please choose a valid square"
  end

  def game_over_message(player)
    "#{player} wins"
  end

  # siphon methods for prompts and inputs
  def user_input
    gets.chomp
  end

  def message(str)
    puts str
  end
end


G = Game.new()

puts G.play
