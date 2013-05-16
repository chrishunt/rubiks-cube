module CubeSolver
  # Very inefficient two-cycle solving algorithm, useful for blindfold
  class TwoCycleSolver
    attr_reader :cube, :solution

    def initialize(cube)
      @cube = cube
    end

    def state
      cube.state
    end

    def solved?
      cube.solved?
    end

    def solve!
      @solution ||= begin
        solution = []
        solution << solution_for(:permutation)
        solution << solution_for(:orientation)
        solution.flatten
      end
    end

    private

    def solution_for(step)
      [:edge, :corner].map do |cubie_type|
        send "#{step}_solution_for", cubie_type
      end
    end

    def permutation_solution_for(cubie_type)
      [].tap do |solution|
        until cube.public_send("has_#{cubie_type}s_permuted?")
          solution << [swap(cubie_type.to_sym, next_location_for(cubie_type))]
        end
      end
    end

    def orientation_solution_for(cubie_type)
      [].tap do |solution|
        until cube.public_send("has_#{cubie_type}s_oriented?")
          solution << [rotate(cubie_type.to_sym)]
        end
      end
    end

    def next_location_for(cubie_type)
      buffer_cubie = send("permutation_buffer_#{cubie_type}")

      if cube.public_send("#{cubie_type}_permuted?", buffer_cubie)
        cube.public_send("unpermuted_#{cubie_type}_locations").first
      else
        cube.permuted_location_for buffer_cubie
      end
    end

    def next_unoriented_location_for(cubie_type)
      cube.public_send("unoriented_#{cubie_type}_locations").tap do |locations|
        locations.delete(0)
      end.first
    end

    def swap(type, location)
      setup = CubeSolver::Algorithms::PLL::Setup.fetch(type).fetch(location)
      swap  = send("#{type}_swap_algorithm")
      undo  = CubeSolver::Algorithms.reverse(setup)

      [setup, swap, undo].map do |algorithm|
        cube.perform! algorithm
        algorithm
      end
    end

    def rotate(type)
      setup = CubeSolver::Algorithms::OLL::Setup.fetch(type).fetch(
        next_unoriented_location_for(type)
      )

      rotate = send("#{type}_rotate_algorithm")
      undo   = CubeSolver::Algorithms.reverse(setup)

      [setup, rotate, undo].map do |algorithm|
        cube.perform! algorithm
        algorithm
      end
    end

    def edge_swap_algorithm
      CubeSolver::Algorithms::PLL::T
    end

    def corner_swap_algorithm
      CubeSolver::Algorithms::PLL::Y
    end

    def edge_rotate_algorithm
      CubeSolver::Algorithms::OLL::I
    end

    def corner_rotate_algorithm
      CubeSolver::Algorithms::OLL::H
    end

    def permutation_buffer_edge
      cube.edges[1]
    end

    def permutation_buffer_corner
      cube.corners[0]
    end
  end
end
