require 'cube_solver/cubie'

module CubeSolver
  # Standard 3x3x3 Rubik's Cube with normal turn operations (l, r, u, d, f, b)
  class Cube
    attr_reader :state

    SOLVED_STATE = %w(
      UF UR UB UL FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL
    )

    def initialize(state)
      @state = build_state_from_string state
    end

    def ==(other)
      state == other.state
    end

    def state
      @state.join ' '
    end

    def solved?
      state == SOLVED_STATE.join(' ')
    end

    def perform!(algorithm)
      algorithm.split.each { |move| perform_move! move }
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

    private

    def build_state_from_string(state)
      state.split.map { |state| CubeSolver::Cubie.new state }
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
  end
end
