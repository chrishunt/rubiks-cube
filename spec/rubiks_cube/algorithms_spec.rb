require 'spec_helper'

describe RubiksCube::Algorithms do
  subject { described_class }

  describe '.reverse' do
    it 'reverses the algorithm' do
      expect(subject.reverse "F' B L2 U' R").to eq "R' U L2 B' F"
    end
  end
end
