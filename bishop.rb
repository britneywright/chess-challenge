require_relative 'board'
require_relative 'diagonal'
require 'pry'
class Bishop
  include Diagonal

  attr_reader :color
  def initialize(color)
    @color = color
    @marker = "B"
  end

  def move?(origin,destination,board)
    dx = destination[0]
    dy = destination[1]
    ox = origin[0]
    oy = origin[1]
    if diagonal?(ox,oy,dx,dy)
      if board[destination] != nil && board[destination].color == @color
        return false
      end
      horizontal = ox - dx < 0 ? -1 : 1
      vertical = oy - dy < 0 ? -1 : 1
      distance = (ox - dx).abs
      until distance == 1 do
        oy += horizontal
        ox += vertical
        if board[[ox,oy]] != nil
          return false
        end
        distance -= 1
      end
      return true
    end
    return false  
  end
end
