module CubeSolver
  # Standard 3x3x3 Rubik's Cube with normal turn operations (l, r, u, d, f, b)
  class Cube
    SOLVED_STATE = %w(
      UF UR UB UL FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL
    )

    def initialize(state = nil)
      @state = build_state_from_string(
        state.to_s.empty? ? SOLVED_STATE.join(' ') : state
      )
    end

    def ==(other)
      state == other.state
    end

    def state
      @state.join ' '
    end

    def edges
      @state[0..11]
    end

    def corners
      @state[12..-1]
    end

    def solved?
      state == SOLVED_STATE.join(' ')
    end

    def edge_permuted?(edge)
      cubie_permuted? :edges, edge
    end

    def corner_permuted?(corner)
      cubie_permuted? :corners, corner
    end

    def has_edges_permuted?
      unpermuted_edge_locations.empty?
    end

    def has_corners_permuted?
      unpermuted_corner_locations.empty?
    end

    def unpermuted_edge_locations
      unpermuted_locations_for :edges
    end

    def unpermuted_corner_locations
      unpermuted_locations_for :corners
    end

    def permuted_location_for(cubie)
      while (location = SOLVED_STATE.index cubie.state) == nil
        cubie = cubie.rotate
      end

      location -= 12 if location >= 12
      location
    end

    def perform!(algorithm)
      algorithm.split.each { |move| perform_move! move }
      algorithm
    end

    def undo!(algorithm)
      perform! reverse(algorithm)
    end

    def r
      turn [1, 5, 9, 6]
      turn [13, 17, 18, 14]
      rotate [13, 13, 14, 17, 18, 18]
      self
    end

    def l
      turn [3, 7, 11, 4]
      turn [12, 15, 19, 16]
      rotate [12, 15, 15, 16, 16, 19]
      self
    end

    def u
      turn [0, 1, 2, 3]
      turn [12, 13, 14, 15]
      self
    end

    def d
      turn [8, 11, 10, 9]
      turn [16, 19, 18, 17]
      self
    end

    def f
      turn [0, 4, 8, 5]
      rotate [0, 4, 8, 5]
      turn [12, 16, 17, 13]
      rotate [12, 12, 13, 16, 17, 17]
      self
    end

    def b
      turn [2, 6, 10, 7]
      rotate [2, 6, 10, 7]
      turn [14, 18, 19, 15]
      rotate [14, 14, 15, 18, 19, 19]
      self
    end

    def m
      turn [0, 2, 10, 8]
      rotate [0, 2, 10, 8]
      self
    end

    private

    def build_state_from_string(state)
      state.split.map { |state| CubeSolver::Cubie.new state }
    end

    def cubie_permuted?(type, cubie)
      send(type).index(cubie) == permuted_location_for(cubie)
    end

    def unpermuted_locations_for(type)
      send(type).each_with_index.map do |cubie, location|
        location == permuted_location_for(cubie) ? nil : location
      end.compact
    end

    def turn(sequence)
      current_cubie = sequence.shift
      first_cubie = @state[current_cubie]

      sequence.each do |cubie|
        @state[current_cubie] = @state[cubie]
        current_cubie = cubie
      end

      @state[current_cubie] = first_cubie
    end

    def rotate(cubies)
      cubies.each { |cubie| @state[cubie].rotate! }
    end

    def perform_move!(move)
      operation = "#{move[0].downcase}"

      case modifier = move[-1]
        when "'"
          3.times { send operation }
        when "2"
          2.times { send operation }
        else
          send operation
      end
    end

    def reverse(algorithm)
      CubeSolver::Algorithms.reverse algorithm
    end
  end
end
