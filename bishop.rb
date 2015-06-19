require_relative 'bishop'
require 'pry'
class Bishop

  attr_reader :color
  def initialize(color)
    @color = color
    @marker = "B"
  end

  def move?(origin, destination, board)
    if board[MAP_HASH.key(destination)] != nil && board[MAP_HASH.key(destination)].color == @color
      return false
    end
    horizontal = (origin[0] - destination[0]  < 0 ? -1 : 1)
    vertical = (origin[1] - destination[1] < 0 ? -1 : 1)
    distance = (origin[0] - destination[0]).abs
    x = origin[0]
    y = origin[1]
    until distance == 1 do
      y += horizontal
      x += vertical
      if board[MAP_HASH.key([x,y])] != nil
        return false
      end
      distance -= 1
    end
    return true
  end
end
