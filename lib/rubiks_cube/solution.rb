module RubiksCube
  # Abstract interface for a RubiksCube solution
  #
  # Must implement:
  #   solution: array or string of moves necessary to solve the cube
  #   pretty:   human readable string of solution
  class Solution
    attr_reader :cube

    # Array or String of moves necessary to solve the cube
    def solution
      raise "#solution unimplemented in #{self.class.name}"
    end

    # Human readable string of solution
    def pretty
      raise "#pretty unimplemented in #{self.class.name}"
    end

    def initialize(cube)
      @cube = Cube.new(cube.state)
    end

    def state
      cube.state
    end

    def solved?
      cube.solved?
    end

    def length
      Array(solution).flatten.join(' ').split.count
    end
  end
end

