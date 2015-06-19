require_relative 'board'
require_relative 'bishop'

RSpec.describe 'Board' do
  let(:board) { Board.new }

  it "initializes with a board hash representing the 64 spaces on the board" do
    'A'.upto 'H' do |char|
      '1'.upto '8' do |num|
        expect(board["#{char}#{num}"]).to eq nil
      end
    end
  end

  it 'can convert chess space to internal coordinates (regardless of case)' do
    expect(Board.intern "a8").to eq [0, 0]
    expect(Board.intern "a1").to eq [7, 0]
    expect(Board.intern "h8").to eq [0, 7]
    expect(Board.intern "h1").to eq [7, 7]

    expect(Board.intern "a8").to eq [0, 0]
    expect(Board.intern "A8").to eq [0, 0]
  end

  it 'raises an error if user attempts to access a nonexistent space' do
    expect { board['I1'] = Bishop.new('white') }.to raise_error KeyError
    expect { board['I1']                       }.to raise_error KeyError

    expect { board['A9'] = Bishop.new('white') }.to raise_error KeyError
    expect { board['A9']                       }.to raise_error KeyError
  end

  context "moves pieces on the board" do
    let(:bishop) { Bishop.new("white") }

    it "makes legal moves" do
      board['D4'] = bishop
      board.move("D4", "G7")
      expect(board["D4"]).to be nil
      expect(board["G7"]).to be bishop
    end

    it "does not make illegal moves" do
      board['D4'] = bishop
      board['G7'] = Bishop.new('white')
      board.move("D4", "G7")
      expect(board["D4"]).to be bishop
      expect(board["G7"]).to_not be nil
    end
  end
end


RSpec.describe 'Bishop' do
  let(:board){Board.new}
  let(:bishop) { Bishop.new("white") }

  it "initializes with a color passed in and a predefined marker" do
    expect(bishop.color).to eq "white"
    expect(bishop.marker).to eq "B"
  end

  context "moves around the board" do
    it "can make a diagonal move on the board into an empty space" do
      board["D4"] = bishop
      expect(bishop.move?([4,3], [1,6], board)).to eq true
    end

    it "can make a diagonal move on the board to capture an opponent piece" do
      board["D4"] = bishop
      board["G7"] = Bishop.new("black")
      expect(bishop.move?([4,3], [1,6], board)).to eq true
    end

    it "cannot make a diagonal move on the board if there is a piece along the path to it's target space" do
      board["D4"] = bishop
      board["F6"] = Bishop.new("black")
      board["G7"] = Bishop.new("black")
      expect(bishop.move?([4,3], [1,6], board)).to eq false
    end

    it "cannot make a diagonal move on the board if there is a piece with it's same color in the target space" do
      board["D4"] = bishop
      board["G7"] = Bishop.new("white")
      expect(bishop.move?([4,3], [1,6], board)).to eq false
    end
  end
end
