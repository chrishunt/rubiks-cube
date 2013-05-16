module CubeSolver
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

    module PLL
      T = "R U R' U' R' F R2 U' R' U' R U R' F'"
      Y = "U F R U' R' U' R U R' F' R U R' U' R' F R F' U'"

      Setup = {
        edge: {
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
        },

        corner: {
          1 => "R2 D' R2",
          2 => "",
          3 => "B2 D' R2",
          4 => "D R2",
          5 => "R2",
          6 => "D' R2",
          7 => "D2 R2",
        }
      }
    end


      }
  end
end
