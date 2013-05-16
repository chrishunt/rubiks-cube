module RubiksCube
  # Generic cubie piece, either edge cubie or corner cubie
  class Cubie
    def initialize(state)
      @cubie = state.size == 2 ? EdgeCubie.new(state) : CornerCubie.new(state)
    end

    def ==(other)
      state == other.state
    end

    def state
      @cubie.state
    end

    def rotate!
      @cubie.rotate!
      self
    end

    def rotate
      Cubie.new(state.dup).rotate!
    end

    def to_s
      @cubie.state
    end
  end
end
