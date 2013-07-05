module RubiksCube
  # Permutation and Orientation algorithms for two-cycle solution
  module Algorithms
    def self.reverse(algorithm)
      algorithm.split.map do |move|
        case modifier = move[-1]
        when "'"
          move[0]
        when "2"
          move
        else
          "#{move}'"
        end
      end.reverse.join ' '
    end

    module Permutation
      Edge = "R U R' U' R' F R2 U' R' U' R U R' F'"
      Corner = "U F R U' R' U' R U R' F' R U R' U' R' F R F' U'"

      module Setup
        Edge = {
          0  => "M2 D L2",
          2  => "M2 D' L2",
          3  => "",
          4  => "U' F U",
          5  => "U' F' U",
          6  => "U B U'",
          7  => "U B' U'",
          8  => "D' L2",
          9  => "D2 L2",
          10 => "D L2",
          11 => "L2"
        }

        Corner = {
          1 => "R2 D' R2",
          2 => "",
          3 => "B2 D' R2",
          4 => "D R2",
          5 => "R2",
          6 => "D' R2",
          7 => "D2 R2"
        }
      end
    end

    module Orientation
      Edge = "M' U M' U M' U2 M U M U M U2"
      Corner = "R' D R F D F' U' F D' F' R' D' R U"

      module Setup
        Edge = {
          1  => "R B",
          2  => "",
          3  => "L' B'",
          4  => "L2 B'",
          5  => "R2 B",
          6  => "B",
          7  => "B'",
          8  => "D2 B2",
          9  => "D B2",
          10 => "B2",
          11 => "D' B2"
        }

        Corner = {
          1 => "",
          2 => "R'",
          3 => "B2 R2",
          4 => "D2 R2",
          5 => "D R2",
          6 => "R2",
          7 => "D' R2"
        }
      end
    end
  end
end
