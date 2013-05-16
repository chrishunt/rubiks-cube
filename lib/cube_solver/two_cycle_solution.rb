require 'cube_solver/cube'
require 'cube_solver/algorithms'

module CubeSolver
  # Very inefficient two-cycle solving algorithm, useful for blindfold
  class TwoCycleSolution
    attr_reader :cube, :solution

    def initialize(state)
      @cube = CubeSolver::Cube.new state
    end

    def state
      cube.state
    end

    def solved?
      cube.solved?
    end

    def solve!
      @solution ||= begin
        solution =  solution_for(:edge)
        solution << solution_for(:corner)

        solution.flatten.compact.join(' ').strip
      end
    end

    private

    def solution_for(cubie)
      [].tap do |solution|
        until cube.public_send("has_#{cubie}s_solved?")
          solution << swap("#{cubie}".to_sym, next_location_for(cubie)) << "\n"
        end
      end
    end

    def next_location_for(cubie)
      buffer_cubie = send("buffer_#{cubie}")

      if cube.public_send("#{cubie}_solved?", buffer_cubie)
        cube.public_send("unsolved_#{cubie}_locations").first
      else
        cube.solved_location_for buffer_cubie
      end
    end

    def swap(type, location)
      setup = CubeSolver::Algorithms::Setup.fetch(type).fetch(location)
      swap  = send("#{type}_swap_algorithm")
      undo  = CubeSolver::Algorithms.reverse(setup)

      %w(setup swap undo).map { |operation| format operation, eval(operation) }
    end

    def format(operation, algorithm)
      "#{operation}\t(#{cube.perform! algorithm})\n" unless algorithm.empty?
    end

    def edge_swap_algorithm
      CubeSolver::Algorithms::PLL::T
    end

    def corner_swap_algorithm
      CubeSolver::Algorithms::PLL::Y
    end

    def buffer_edge
      cube.edges[1]
    end

    def buffer_corner
      cube.corners[0]
    end
  end
end
