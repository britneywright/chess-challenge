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

__END__
describe 'Bishop' do
  let(:bishop) {Bishop.new("white")}

  it "initializes with a color passed in and a predefined marker" do
    expect(bishop.color).to eq "white"
    expect(bishop.instance_variable_get(:@marker)).to eq "B"
  end

  context "moves around the board" do
    let(:chess_board){Board.new}

    it "can make a diagonal move on the board into an empty space" do
      chess_board.instance_variable_set(:@board,
           {"A8" => nil, "B8" => nil, "C8" => nil, "D8" => nil, "E8" => nil, "F8" => nil, "G8" => nil, "H8" => nil,
            "A7" => nil, "B7" => nil, "C7" => nil, "D7" => nil, "E7" => nil, "F7" => nil, "G7" => nil, "H7" => nil,
            "A6" => nil, "B6" => nil, "C6" => nil, "D6" => nil, "E6" => nil, "F6" => nil, "G6" => nil, "H6" => nil,
            "A5" => nil, "B5" => nil, "C5" => nil, "D5" => nil, "E5" => nil, "F5" => nil, "G5" => nil, "H5" => nil,
            "A4" => nil, "B4" => nil, "C4" => nil, "D4" => bishop, "E4" => nil, "F4" => nil, "G4" => nil, "H4" => nil,
            "A3" => nil, "B3" => nil, "C3" => nil, "D3" => nil, "E3" => nil, "F3" => nil, "G3" => nil, "H3" => nil,
            "A2" => nil, "B2" => nil, "C2" => nil, "D2" => nil, "E2" => nil, "F2" => nil, "G2" => nil, "H2" => nil,
            "A1" => nil, "B1" => nil, "C1" => nil, "D1" => nil, "E1" => nil, "F1" => nil, "G1" => nil, "H1" => nil })

      expect(bishop.move?([4,3],[1,6],chess_board.board)).to eq true
    end

    it "can make a diagonal move on the board to capture an opponent piece" do
      chess_board.instance_variable_set(:@board,
           {"A8" => nil, "B8" => nil, "C8" => nil, "D8" => nil, "E8" => nil, "F8" => nil, "G8" => nil, "H8" => nil,
            "A7" => nil, "B7" => nil, "C7" => nil, "D7" => nil, "E7" => nil, "F7" => nil, "G7" => Bishop.new("black"), "H7" => nil,
            "A6" => nil, "B6" => nil, "C6" => nil, "D6" => nil, "E6" => nil, "F6" => nil, "G6" => nil, "H6" => nil,
            "A5" => nil, "B5" => nil, "C5" => nil, "D5" => nil, "E5" => nil, "F5" => nil, "G5" => nil, "H5" => nil,
            "A4" => nil, "B4" => nil, "C4" => nil, "D4" => bishop, "E4" => nil, "F4" => nil, "G4" => nil, "H4" => nil,
            "A3" => nil, "B3" => nil, "C3" => nil, "D3" => nil, "E3" => nil, "F3" => nil, "G3" => nil, "H3" => nil,
            "A2" => nil, "B2" => nil, "C2" => nil, "D2" => nil, "E2" => nil, "F2" => nil, "G2" => nil, "H2" => nil,
            "A1" => nil, "B1" => nil, "C1" => nil, "D1" => nil, "E1" => nil, "F1" => nil, "G1" => nil, "H1" => nil })

      expect(bishop.move?([4,3],[1,6],chess_board.board)).to eq true
    end

    it "cannot make a diagonal move on the board if there is a piece along the path to it's target space" do
      chess_board.instance_variable_set(:@board,
           {"A8" => nil, "B8" => nil, "C8" => nil, "D8" => nil, "E8" => nil, "F8" => nil, "G8" => nil, "H8" => nil,
            "A7" => nil, "B7" => nil, "C7" => nil, "D7" => nil, "E7" => nil, "F7" => nil, "G7" => Bishop.new("black"), "H7" => nil,
            "A6" => nil, "B6" => nil, "C6" => nil, "D6" => nil, "E6" => nil, "F6" => Bishop.new("black"), "G6" => nil, "H6" => nil,
            "A5" => nil, "B5" => nil, "C5" => nil, "D5" => nil, "E5" => nil, "F5" => nil, "G5" => nil, "H5" => nil,
            "A4" => nil, "B4" => nil, "C4" => nil, "D4" => bishop, "E4" => nil, "F4" => nil, "G4" => nil, "H4" => nil,
            "A3" => nil, "B3" => nil, "C3" => nil, "D3" => nil, "E3" => nil, "F3" => nil, "G3" => nil, "H3" => nil,
            "A2" => nil, "B2" => nil, "C2" => nil, "D2" => nil, "E2" => nil, "F2" => nil, "G2" => nil, "H2" => nil,
            "A1" => nil, "B1" => nil, "C1" => nil, "D1" => nil, "E1" => nil, "F1" => nil, "G1" => nil, "H1" => nil })

      expect(bishop.move?([4,3],[1,6],chess_board.board)).to eq false
    end

    it "cannot make a diagonal move on the board if there is a piece with it's same color in the target space" do
      chess_board.instance_variable_set(:@board,
           {"A8" => nil, "B8" => nil, "C8" => nil, "D8" => nil, "E8" => nil, "F8" => nil, "G8" => nil, "H8" => nil,
            "A7" => nil, "B7" => nil, "C7" => nil, "D7" => nil, "E7" => nil, "F7" => nil, "G7" => Bishop.new("white"), "H7" => nil,
            "A6" => nil, "B6" => nil, "C6" => nil, "D6" => nil, "E6" => nil, "F6" => nil, "G6" => nil, "H6" => nil,
            "A5" => nil, "B5" => nil, "C5" => nil, "D5" => nil, "E5" => nil, "F5" => nil, "G5" => nil, "H5" => nil,
            "A4" => nil, "B4" => nil, "C4" => nil, "D4" => bishop, "E4" => nil, "F4" => nil, "G4" => nil, "H4" => nil,
            "A3" => nil, "B3" => nil, "C3" => nil, "D3" => nil, "E3" => nil, "F3" => nil, "G3" => nil, "H3" => nil,
            "A2" => nil, "B2" => nil, "C2" => nil, "D2" => nil, "E2" => nil, "F2" => nil, "G2" => nil, "H2" => nil,
            "A1" => nil, "B1" => nil, "C1" => nil, "D1" => nil, "E1" => nil, "F1" => nil, "G1" => nil, "H1" => nil })

      expect(bishop.move?([4,3],[1,6],chess_board.board)).to eq false
    end
  end
end
