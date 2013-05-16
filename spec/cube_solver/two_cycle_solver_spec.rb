require 'spec_helper'

describe CubeSolver::TwoCycleSolver do
  subject { described_class.new cube }

  let(:cube)  { CubeSolver::Cube.new state }
  let(:state) { nil }

  describe '#solve!' do
    shared_examples_for 'a cube that can be solved' do
      it 'solves the cube' do
        subject.solve!
        expect(subject).to be_solved
      end
    end

    context 'when edges need to be swapped' do
      let(:state) {
        'UF UL UB UR FL FR BR BL DF DR DB DL UFL UBR URF ULB DLF DFR DRB DBL'
      }

      it_should_behave_like 'a cube that can be solved'

      it 'returns the solution and saves it for later' do
        expected_solution = "swap\t(#{CubeSolver::Algorithms::PLL::T})"

        expect(subject.solution).to be_nil
        expect(subject.solve!).to eq expected_solution
        expect(subject.solution).to eq expected_solution
      end
    end

    context 'when corners need to be swapped' do
      let(:state) {
        'UL UR UB UF FL FR BR BL DF DR DB DL UBR URF UFL ULB DLF DFR DRB DBL'
      }

      it_should_behave_like 'a cube that can be solved'
    end

    context 'when two edges have incorrect orientation' do
      before { cube.perform! CubeSolver::Algorithms::OLL::I }

      it_should_behave_like 'a cube that can be solved'
    end

    context 'when two corners have incorrect orientation' do
      before { cube.perform! CubeSolver::Algorithms::OLL::H }

      it_should_behave_like 'a cube that can be solved'
    end

    [
      "U2 L' F2 U' B D' R' F2 U F' R L2 F2 L' B L R2 B' D R L' U D' R2 F'",
      "L U2 R' B2 U D R' U R' B2 L F R2 L' B' R' U2 L2 R2 U F' L' U' L U'",
      "F' U2 D2 F2 R' D2 B L2 F L2 D2 F U2 F B L U' D' R' F D F' L2 F' B2",
      "R2 U' D2 B L2 U' R D2 L2 U2 F2 D' B' L B' D L' B2 L' F' L' B2 F2 U' L2",
      "L2 R D' U2 R L' B2 U' L2 D2 B2 D' R2 L' B' U2 B R2 F2 R' D' F2 D L U",
    ].each do |scramble|
      context "with scramble (#{scramble})" do
        before { cube.perform! scramble }

        it_should_behave_like 'a cube that can be solved'
      end
    end
  end
end
