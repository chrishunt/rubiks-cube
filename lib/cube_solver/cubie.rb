require 'cube_solver/edge_cubie'
require 'cube_solver/corner_cubie'

module CubeSolver
  class Cubie
    def initialize(state)
      @cubie = state.size == 2 ? EdgeCubie.new(state) : CornerCubie.new(state)
    end

    def state
      @cubie.state
    end

    def rotate!
      @cubie.rotate!
      self
    end
  end
end
