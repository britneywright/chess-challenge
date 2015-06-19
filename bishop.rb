require_relative 'bishop'
require 'pry'
class Bishop

  attr_reader :color
  def initialize(color)
    @color = color
    @marker = "B"
  end

  def move?(origin, destination, board)
    if board.my_team? destination, @color
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
      if board[x, y]
        return false
      end
      distance -= 1
    end
    return true
  end
end
