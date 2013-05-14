require 'cube_solver/cube'

describe CubeSolver::Cube do
  subject { described_class.new state }

  let(:state) { solved_state }

  let(:solved_state) { CubeSolver::Cube::SOLVED_STATE }

  it 'is initialized with a state' do
    expect(subject.state).to eq state
  end

  describe '#solved?' do
    it 'returns true when cube is solved' do
      expect(subject.solved?).to be_true
    end

    it 'returns false when cube is not solved' do
      subject.l!.r!
      expect(subject.solved?).to be_false
    end
  end

  describe '#perform!' do
    it 'performs the algorithm on the cube' do
      subject.perform! "U2 D' L R F B"

      expect(subject.state).to eq(
        described_class.new(solved_state).u!.u!.d!.d!.d!.l!.r!.f!.b!.state
      )
    end
  end

  describe '#r!' do
    it 'turns the right face 90 degrees clockwise' do
      subject.r!

      expect(subject.state).to eq(
        'UF FR UB UL FL DR UR BL DF BR DB DL UFL FRD FUR ULB DLF BDR BRU DBL'
      )
    end
  end

  describe '#l!' do
    it 'turns the left face 90 degrees clockwise' do
      subject.l!

      expect(subject.state).to eq(
        'UF UR UB BL UL FR BR DL DF DR DB FL BUL URF UBR BLD FLU DFR DRB FDL'
      )
    end
  end

  describe '#u!' do
    it 'turns the up face 90 degrees clockwise' do
      subject.u!

      expect(subject.state).to eq(
        'UR UB UL UF FL FR BR BL DF DR DB DL URF UBR ULB UFL DLF DFR DRB DBL'
      )
    end
  end

  describe '#d!' do
    it 'turns the down face 90 degrees clockwise' do
      subject.d!

      expect(subject.state).to eq(
        'UF UR UB UL FL FR BR BL DL DF DR DB UFL URF UBR ULB DBL DLF DFR DRB'
      )
    end
  end

  describe '#f!' do
    it 'turns the front face 90 degrees clockwise' do
      subject.f!

      expect(subject.state).to eq(
        'LF UR UB UL FD FU BR BL RF DR DB DL LFD LUF UBR ULB RDF RFU DRB DBL'
      )
    end
  end

  describe '#b!' do
    it 'turns the back face 90 degrees clockwise' do
      subject.b!

      expect(subject.state).to eq(
        'UF UR RB UL FL FR BD BU DF DR LB DL UFL URF RBD RUB DLF DFR LDB LBU'
      )
    end
  end
end
