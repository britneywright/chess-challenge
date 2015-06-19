class Knight
  def initialize(color)
    @color = color
    @marker = "K"
  end

  def move?(origin,destination,board)
    if board[destination] != nil && board[destination].color == @color
      return false
    end
    
    possible_coords = [[-1,-2],[1, -2], [2, -1], [2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1]] 
    possible_destinations = possible_coords.map do |x, y|
      [origin[0] + x, origin[1] + y]
    end

  end

end

