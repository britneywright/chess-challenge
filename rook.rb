require_relative 'board'
require_relative 'straight'
require 'pry'

class Rook
  include Straight
  attr_reader :color
  
  def initialize(color)
    @color = color
    @marker = "R"
  end

  def move?(origin,destination,board)
    dx = destination[0]
    dy = destination[1]
    ox = origin[0]
    oy = origin[1]
    if straight?(ox,oy,dx,dy)
      if board[destination] != nil && board[destination].color == @color
        return false
      end
      if ox - dx == 0
        horizontal = 0
        vertical = (oy - dy < 0 ? 1 : -1)
        distance = (oy - dy).abs
        until distance == 1 do
          oy += vertical
          if board[[ox,oy]] != nil
            return false
          end
          distance -= 1
        end
        return true
      else
        vertical = 0
        horizontal = (ox - dx < 0 ? 1 : -1)
        distance = (ox - dx).abs
        until distance == 1 do
          ox += horizontal
          if board[[ox,oy]] != nil
            return false
          end
          distance -= 1
        end
        return true 
      end
    end
    return false  
  end
end
