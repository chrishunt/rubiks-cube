require 'cube_solver/cubie'

describe CubeSolver::Cubie do
  subject { described_class.new state }

  let(:state) { 'UF' }

  it 'is initialized with a state' do
    expect(subject.state).to eq state
  end

  describe '#to_s' do
    it 'converts the cubie to a string' do
      expect(subject.to_s).to eq state
    end
  end

  context 'with an edge piece' do
    let(:state) { 'UF' }

    describe '#rotate!' do
      it 'flips the cubie' do
        expect(subject.rotate!.state).to eq 'FU'
        expect(subject.rotate!.state).to eq state
      end
    end
  end

  context 'with a corner piece' do
    let(:state) { 'URF' }

    describe '#rotate!' do
      it 'rotates the cubie once couter clockwise' do
        expect(subject.rotate!.state).to eq 'FUR'
        expect(subject.rotate!.state).to eq 'RFU'
        expect(subject.rotate!.state).to eq state
      end
    end
  end
end
