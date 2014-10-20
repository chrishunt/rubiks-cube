require 'spec_helper'

module RubiksCube
  describe BicycleSolution do
    it 'is an alias for TwoCycleSolution' do
      cube = double('RubiksCube::Cube')
      allow(TwoCycleSolution).to receive(:new)

      BicycleSolution.new(cube)

      expect(TwoCycleSolution).to have_received(:new).with(cube)
    end
  end
end
