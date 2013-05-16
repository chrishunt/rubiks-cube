module RubiksCube
  EdgeCubie = Struct.new(:state) do
    def rotate!
      state.reverse!
    end
  end
end
