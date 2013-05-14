require 'cube_solver/cube'

module CubeSolver
  # Very inefficient two-cycle solving algorithm, useful for learning
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
