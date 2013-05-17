module RubiksCube
  # Generic cubie piece, either edge cubie or corner cubie
  Cubie = Struct.new(:state) do
    def ==(other)
      state == other.state
    end

    def rotate!
      self.state = state.split('').rotate.join
      self
    end

    def rotate
      Cubie.new(state.dup).rotate!
    end

    def to_s
      state
    end
  end
end
