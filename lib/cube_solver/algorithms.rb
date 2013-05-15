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
    end
  end
end
