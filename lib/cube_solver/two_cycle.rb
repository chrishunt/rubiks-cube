require 'cube_solver/cube'

module CubeSolver
  class TwoCycle
    attr_reader :cube

    def initialize(state)
      @cube = CubeSolver::Cube.new state
    end

    def state
      cube.state
    end
  end
end
