module CubeSolver
  CornerCubie = Struct.new(:state) do
    def rotate!
      u, r, f = state.split ''
      self.state = [f, u, r].join
    end
  end
end
