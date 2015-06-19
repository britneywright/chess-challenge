require_relative 'chess_controller'
require_relative 'board'
require_relative 'bishop'
require_relative 'rook'

RSpec.describe 'Controller' do
  it 'can convert user passed coordinate string to internal coordinates (regardless of case)' do
    expect(convert_user_to_board "a8").to eq [0,0]
    expect(convert_user_to_board "a1").to eq [7,0]
    expect(convert_user_to_board "H8").to eq [0,7]
    expect(convert_user_to_board "H1").to eq [7,7]
  end

  it 'can convert internal coordinates to user string representation' do
    expect(convert_board_to_user [0,0]).to eq "A8"
    expect(convert_board_to_user [7,0]).to eq "A1"
    expect(convert_board_to_user [0,7]).to eq "H8"
    expect(convert_board_to_user [7,7]).to eq "H1"
  end

end

describe 'Board' do
  let(:board) {Board.new}
   #it "initializes with a board hash representing the 64 spaces on the board" do
   #   expect(board.board.size).to eq 64
    #end

  context "moves pieces on the board" do
    let(:bishop) {Bishop.new("white")}
   
    pending it 'raises an error if user attempts to access a nonexistent space' do
      expect(board[:'81']).to raise_error KeyError
    end

    it "makes legal moves" do
      board[[4,3]] = bishop
      board.move_piece([4,3],[1,6])

      expect(board[[4,3]]).to be nil
      expect(board[[1,6]]).to be bishop
    end

    it "does not make illegal moves" do
      board[[4,3]] = bishop
      board[[1,6]] = Bishop.new("white")

      board.move_piece([4,3],[1,6])

      expect(board[[4,3]]).to be bishop
      expect(board[[1,6]]).to_not be nil
    end
  end
end

describe 'Bishop' do
  let(:bishop) {Bishop.new("white")}

  it "initializes with a color passed in and a predefined marker" do
    expect(bishop.color).to eq "white"
  end

  context "moves around the board" do
    let(:board){Board.new}

    it "can make a diagonal move on the board into an empty space" do
      board[[4,3]] = bishop

      expect(bishop.move?([4,3],[1,6],board)).to eq true
    end

    it "can make a diagonal move on the board to capture an opponent piece" do
      board[[4,3]] = bishop
      board[[1,6]] = Bishop.new("black")

      expect(bishop.move?([4,3],[1,6],board)).to eq true
    end

    it "cannot make a diagonal move on the board if there is a piece along the path to it's target space" do
      board[[4,3]] = bishop
      board[[2,5]] = Bishop.new("black")

      expect(bishop.move?([4,3],[1,6],board)).to eq false
    end

    it "cannot make a diagonal move on the board if there is a piece with it's same color in the target space" do
      board[[4,3]] = bishop
      board[[1,6]] = Bishop.new("white")

      expect(bishop.move?([4,3],[1,6],board)).to eq false
    end

    it "cannot make a horizontal move on the board" do
      board[[4,3]] = bishop

      expect(bishop.move?([4,3],[4,5],board)).to eq false
    end

    it "cannot make a vertical move on the board" do
      board[[4,3]] = bishop
     
      expect(bishop.move?([4,3],[3,3],board)).to eq false
    end
  end
end

describe 'Rook' do
  let(:rook) {Rook.new("white")}

  it "initializes with a color passed in and a predefined marker" do
    expect(rook.color).to eq "white"
  end

  context "moves around the board" do
    let(:board){Board.new}

    it "can move horizontally or vertically on the board through empty spaces into an empty space" do
      board[[4,3]] = rook

      expect(rook.move?([4,3],[4,6],board)).to eq true
      #expect(rook.move?([4,6],[6,6],board)).to eq true
    end

    it "can move horizontally or vertically on the board to capture an opponent piece" do
      board[[4,3]] = rook
      board[[4,6]] = Rook.new("black")
      board[[6,6]] = Rook.new("black")

      expect(rook.move?([4,3],[4,6],board)).to eq true
      expect(rook.move?([4,6],[6,6],board)).to eq true
    end

    it "cannot make a move on the board if there is a piece along the path to it's target space" do
      board[[4,3]] = rook
      board[[2,3]] = Rook.new("black")
      board[[4,5]] = Rook.new("black")

      expect(rook.move?([4,3],[1,3],board)).to eq false
      expect(rook.move?([4,3],[4,6],board)).to eq false
    end

    it "cannot make a move on the board if there is a piece with it's same color in the target space" do
      board[[4,3]] = rook
      board[[4,6]] = Bishop.new("white")
      board[[2,3]] = Bishop.new("white")

      expect(rook.move?([4,3],[4,6],board)).to eq false
      expect(rook.move?([4,3],[2,3],board)).to eq false
    end

    it "cannot make a move on the board that isn't horizontal or vertical" do
      board[[4,3]] = rook
     
      expect(rook.move?([4,3],[3,2],board)).to eq false
    end
  end
end
