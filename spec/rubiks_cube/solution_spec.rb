require 'spec_helper'

describe RubiksCube::Solution do
  class TestSolution < RubiksCube::Solution
    def initialize(cube, solution)
      @solution = solution
      super cube
    end

    def solution; @solution; end
  end

  subject { TestSolution.new(double('Cube', state: 'nope'), solution) }

  describe '#length' do
    context 'when the solution is a single array' do
      let(:solution) { %w(a b c) }

      it 'returns the length of the solution' do
        expect(subject.length).to eq 3
      end
    end

    context 'when the solution contains multiple arrays' do
      let(:solution) { [%w(a b), %w(c d), [%w(e f)]] }

      it 'returns the length of the solution' do
        expect(subject.length).to eq 6
      end
    end

    context 'when the solution is a string' do
      let(:solution) { "a b c d" }

      it 'returns the length of the solution' do
        expect(subject.length).to eq 4
      end
    end
  end
end
