require 'cube_solver/two_cycle'

describe CubeSolver::TwoCycle do
  subject { described_class.new state }

  let(:state) { solved_state }

  let(:solved_state) {
    'UF UR UB UL FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL'
  }

  it 'is initialized with a cube state' do
    expect(subject.state).to eq state
  end
end
