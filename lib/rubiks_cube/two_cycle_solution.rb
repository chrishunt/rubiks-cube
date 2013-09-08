module RubiksCube
  # Very inefficient two-cycle solving algorithm, useful for blindfold
  class TwoCycleSolution
    attr_reader :cube

    def initialize(cube)
      @cube = Cube.new(cube.state)
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

    def solution
      solve!
    end

    def length
      solution.join(' ').split.count
    end

    def pretty
      solution.each_slice(3).map do |setup, correction, undo|
        step = []
        step << "Setup:\t#{setup}" unless setup.empty?
        step << "Fix:\t#{correction}"
        step << "Undo:\t#{undo}" unless undo.empty?
        step.join "\n"
      end.join("\n\n").strip
    end

    private

    def solution_for(step)
      [:edge, :corner].map do |cubie|
        solve_for cubie, step
      end
    end

    def solve_for(cubie, step)
      solution = []
      solution << [perform(cubie, step)] until finished_with?(cubie, step)
      solution
    end

    def finished_with?(cubie, step)
      cube.public_send "has_correct_#{cubie}_#{step}?"
    end

    def perform(cubie, step)
      algorithms_for(cubie, step).map { |algorithm| cube.perform! algorithm }
    end

    def next_orientation_location_for(cubie)
      incorrect_locations_for(cubie, :orientation).tap do |locations|
        locations.delete(0)
      end.first
    end

    def next_permutation_location_for(cubie)
      buffer_cubie = send("permutation_buffer_#{cubie}")

      if cube.public_send("#{cubie}_permuted?", buffer_cubie)
        incorrect_locations_for(cubie, :permutation).first
      else
        cube.permuted_location_for buffer_cubie
      end
    end

    def permutation_buffer_edge
      cube.edges[1]
    end

    def permutation_buffer_corner
      cube.corners[0]
    end

    def incorrect_locations_for(cubie, step)
      cube.public_send "incorrect_#{cubie}_#{step}_locations"
    end

    def algorithms_for(cubie, step)
      location   = send("next_#{step}_location_for", cubie)
      setup      = setup_algorithms_for(cubie, step, location)
      correction = correction_algorithm_for(cubie, step)
      undo       = RubiksCube::Algorithms.reverse(setup)

      [ setup, correction, undo ]
    end

    def correction_algorithm_for(cubie, step)
      load_algorithms step, cubie
    end

    def setup_algorithms_for(cubie, step, location)
      load_algorithms(step, :setup, cubie).fetch(location)
    end

    def load_algorithms(*modules)
      [ 'RubiksCube',
        'Algorithms',
        *modules.map(&:capitalize)
      ].inject(Kernel) { |klass, mod| klass.const_get mod }
    end
  end
end
