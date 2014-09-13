require 'spec_helper'

describe RubiksCube::Cubie do
  subject { described_class.new state }

  let(:state) { 'UF' }

  it 'is initialized with a state' do
    expect(subject.state).to eq state
  end

  describe '==' do
    context 'when the state equals the state of the other' do
      it 'returns true' do
        expect(subject == described_class.new(state)).to be true
      end
    end

    context 'when the state does not equal the state of the other' do
      it 'returns false' do
        expect(subject == described_class.new('UB')).to be false
      end
    end
  end

  describe '#to_s' do
    it 'converts the cubie to a string' do
      expect(subject.to_s).to eq state
    end
  end

  describe '#rotate!' do
    context 'with an edge piece' do
      let(:state) { 'UF' }

      it 'flips the cubie' do
        expect(subject.rotate!.state).to eq 'FU'
        expect(subject.rotate!.state).to eq state
      end
    end

    context 'with a corner piece' do
      let(:state) { 'URF' }

      it 'rotates the cubie once couter clockwise' do
        expect(subject.rotate!.state).to eq 'RFU'
        expect(subject.rotate!.state).to eq 'FUR'
        expect(subject.rotate!.state).to eq state
      end
    end
  end

  describe '#rotate' do
    it "returns a new cubie that's been rotated" do
      expect(subject.rotate).to eq described_class.new(state).rotate!
    end

    it 'does not modify the cubie' do
      original_state = subject.state.dup

      subject.rotate

      expect(subject.state).to eq original_state
    end
  end
end
