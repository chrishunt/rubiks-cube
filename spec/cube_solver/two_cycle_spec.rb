require 'cube_solver/two_cycle'

describe CubeSolver::TwoCycle do
  subject { described_class.new state }

  let(:state) { solved_state }

  let(:solved_state) { CubeSolver::Cube::SOLVED_STATE.join ' ' }

  it 'is initialized with a cube state' do
    expect(subject.state).to eq state
  end
end
