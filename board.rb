require_relative 'bishop'
require 'pry'

class Board
  MAP_HASH = {A8: [0,0], B8: [0,1], C8: [0,2], D8: [0,3], E8: [0,4], F8: [0,5], G8: [0,6], H8: [0,7],
              A7: [1,0], B7: [1,1], C7: [1,2], D7: [1,3], E7: [1,4], F7: [1,5], G7: [1,6], H7: [1,7],
              A6: [2,0], B6: [2,1], C6: [2,2], D6: [2,3], E6: [2,4], F6: [2,5], G6: [2,6], H6: [2,7],
              A5: [3,0], B5: [3,1], C5: [3,2], D5: [3,3], E5: [3,4], F5: [3,5], G5: [3,6], H5: [3,7],
              A4: [4,0], B4: [4,1], C4: [4,2], D4: [4,3], E4: [4,4], F4: [4,5], G4: [4,6], H4: [4,7],
              A3: [5,0], B3: [5,1], C3: [5,2], D3: [5,3], E3: [5,4], F3: [5,5], G3: [5,6], H3: [5,7],
              A2: [6,0], B2: [6,1], C2: [6,2], D2: [6,3], E2: [6,4], F2: [6,5], G2: [6,6], H2: [6,7],
              A1: [7,0], B1: [7,1], C1: [7,2], D1: [7,3], E1: [7,4], F1: [7,5], G1: [7,6], H1: [7,7] }

  attr_reader :board
  def initialize
    @board = {A8: nil, B8: nil, C8: nil, D8: nil, E8: nil, F8: nil, G8: nil, H8: nil,
              A7: nil, B7: nil, C7: nil, D7: nil, E7: nil, F7: nil, G7: nil, H7: nil,
              A6: nil, B6: nil, C6: nil, D6: nil, E6: nil, F6: nil, G6: nil, H6: nil,
              A5: nil, B5: nil, C5: nil, D5: nil, E5: nil, F5: nil, G5: nil, H5: nil,
              A4: nil, B4: nil, C4: nil, D4: nil, E4: nil, F4: nil, G4: nil, H4: nil,
              A3: nil, B3: nil, C3: nil, D3: nil, E3: nil, F3: nil, G3: nil, H3: nil,
              A2: nil, B2: nil, C2: nil, D2: nil, E2: nil, F2: nil, G2: nil, H2: nil,
              A1: nil, B1: nil, C1: nil, D1: nil, E1: nil, F1: nil, G1: nil, H1: nil }
  end

  def my_team?(destination, color)
    piece = board[MAP_HASH.key destination]
    piece && piece.color == color
  end

  def [](space_or_x, y=nil)
    if y
      board[MAP_HASH.key [space_or_x, y]]
    else
      space = space_or_x.to_sym
      return board[space] if board.key?(space)
      raise KeyError, "Invalid board space: #{space.inspect}"
    end
  end

  def []=(space, piece)
    space = space.to_sym
    return board[space] = piece if board.key?(space)
    raise KeyError, "Invalid board space: #{space.inspect}"
  end

  def move(origin, destination)
    origin      = origin.to_sym
    destination = destination.to_sym

    converted_origin      = convert_user_to_board(origin)
    converted_destination = convert_user_to_board(destination)

    if self[origin].move?(converted_origin, converted_destination, self)
      self[destination] = self[origin]
      self[origin] = nil
    end
  end

  def to_s
    @board
  end

  private

  def convert_board_to_user(board_coord)
    MAP_HASH.key(board_coord)
  end

  def convert_user_to_board(user_coord)
    MAP_HASH[user_coord]
  end

end
