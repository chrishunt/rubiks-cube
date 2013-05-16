require 'spec_helper'

describe CubeSolver::Cube do
  subject { described_class.new state }

  let(:state) { nil }

  describe '#initialize' do
    context 'when a state is provided' do
      let(:state) { 'some state' }

      it 'is initialized with the state' do
        expect(subject.state).to eq state
      end
    end

    context 'when no state is provided' do
      let(:state) { nil }

      it 'is initialized with the solved state' do
        expect(subject.state).to eq CubeSolver::Cube::SOLVED_STATE.join ' '
      end
    end
  end

  describe '==' do
    it 'returns true when two cubes have the same state' do
      expect(subject).to eq described_class.new(state)
    end

    it 'returns false when two cubes do not have the same state' do
      expect(subject).to_not eq described_class.new(state).d
    end
  end

  describe '#edges' do
    it 'returns all the edges' do
      expect(subject.edges).to eq(
        subject.state.split[0..11].map { |cubie| CubeSolver::Cubie.new cubie }
      )
    end
  end

  describe '#corners' do
    it 'returns all the corners' do
      expect(subject.corners).to eq(
        subject.state.split[12..-1].map { |cubie| CubeSolver::Cubie.new cubie }
      )
    end
  end

  describe '#unpermuted_edge_locations' do
    context 'with unpermuted edges' do
      let(:state) {
        'UF UL UB UR FL FR BR BL DF DL DB DR UFL URF UBR ULB DLF DFR DRB DBL'
      }

      it 'returns the location of all unpermuted edges' do
        expect(subject.unpermuted_edge_locations).to eq [1, 3, 9, 11]
      end
    end

    context 'with permuted edges' do
      it 'returns an empty array' do
        expect(subject.unpermuted_edge_locations).to eq []
      end
    end
  end

  describe '#unpermuted_corner_locations' do
    context 'with unpermuted corners' do
      let(:state){
        'UF UR UB UL FL FR BR BL DF DR DB DL ULB UBR URF UFL DLF DFR DRB DBL'
      }

      it 'returns the locations of all unpermuted corners' do
        expect(subject.unpermuted_corner_locations).to eq [0, 1, 2, 3]
      end
    end

    context 'with permuted corners' do
      it 'returns an empty array' do
        expect(subject.unpermuted_corner_locations).to eq []
      end
    end
  end

  describe '#permuted_location_for' do
    CubeSolver::Cube::SOLVED_STATE.each_with_index do |cubie, location|
      it "returns the correct location for the '#{cubie}' cubie" do
        # Both corner and edge index begins at zero
        location -= 12 if location >= 12

        cubie = CubeSolver::Cubie.new cubie

        expect(subject.permuted_location_for cubie).to eq location
      end
    end

    context 'when the cubie has been rotated' do
      let(:cubie) { subject.corners.first }

      before { cubie.rotate! }

      it 'still finds the correct location' do
        expect(subject.permuted_location_for cubie).to eq 0
      end

      it 'does not rotate the cubie' do
        original_state = cubie.state

        subject.permuted_location_for cubie

        expect(cubie.state).to eq original_state
      end
    end
  end

  describe '#solved?' do
    it 'returns true when cube is solved' do
      expect(subject).to be_solved
    end

    it 'returns false when cube is not solved' do
      subject.l
      expect(subject).to_not be_solved
    end
  end

  describe '#edge_permuted?' do
    it 'returns true when the cubie is permuted' do
      subject.u

      permuted_edge = subject.edges[4]
      unpermuted_edge = subject.edges[0]

      expect(subject.edge_permuted? unpermuted_edge).to be_false
      expect(subject.edge_permuted? permuted_edge).to be_true
    end
  end

  describe '#corner_permuted?' do
    it 'returns true when the cubie is permuted' do
      subject.f

      permuted_corner = subject.corners[2]
      unpermuted_corner = subject.corners[1]

      expect(subject.corner_permuted? unpermuted_corner).to be_false
      expect(subject.corner_permuted? permuted_corner).to be_true
    end
  end

  describe '#has_edges_permuted?' do
    context 'when the edges are permuted, but corners are not' do
      let(:state) {
        'UF UR UB UL FL FR BR BL DF DR DB DL ULB UBR URF UFL DBL DRB DFR DLF'
      }

      it 'returns true' do
        expect(subject).to have_edges_permuted
      end
    end

    context 'when the edges are not permuted, but corners are' do
      let(:state) {
        'UL UF UB UR FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL'
      }

      it 'returns false' do
        expect(subject).to_not have_edges_permuted
      end
    end
  end

  describe '#has_corners_permuted?' do
    context 'when the corners are permuted, but the edges are not' do
      let(:state) {
        'UL UF UB UR FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL'
      }

      it 'returns true' do
        expect(subject).to have_corners_permuted
      end
    end

    context 'when the corners are not permuted, but the edges are permuted' do
      let(:state) {
        'UF UR UB UL FL FR BR BL DF DR DB DL ULB UBR URF UFL DBL DRB DFR DLF'
      }

      it 'returns false' do
        expect(subject).to_not have_corners_permuted
      end
    end
  end

  describe '#perform!' do
    it 'performs the algorithm on the cube' do
      subject.perform! "U2 D' L R F B"

      expect(subject.state).to eq(
        described_class.new.u.u.d.d.d.l.r.f.b.state
      )
    end

    it 'returns the algorithm that was performed' do
      algorithm = "F2 U' L"

      expect(subject.perform! algorithm).to eq algorithm
    end
  end

  describe '#undo!' do
    it 'performs the algorithm in reverse on the cube' do
      subject.f.f.f.b.l.l.u.u.u.r

      subject.undo! "F' B L2 U' R"

      expect(subject).to be_solved
    end
  end

  describe '#r' do
    it 'turns the right face 90 degrees clockwise' do
      subject.r

      expect(subject.state).to eq(
        'UF FR UB UL FL DR UR BL DF BR DB DL UFL FRD FUR ULB DLF BDR BRU DBL'
      )
    end
  end

  describe '#l' do
    it 'turns the left face 90 degrees clockwise' do
      subject.l

      expect(subject.state).to eq(
        'UF UR UB BL UL FR BR DL DF DR DB FL BUL URF UBR BLD FLU DFR DRB FDL'
      )
    end
  end

  describe '#u' do
    it 'turns the up face 90 degrees clockwise' do
      subject.u

      expect(subject.state).to eq(
        'UR UB UL UF FL FR BR BL DF DR DB DL URF UBR ULB UFL DLF DFR DRB DBL'
      )
    end
  end

  describe '#d' do
    it 'turns the down face 90 degrees clockwise' do
      subject.d

      expect(subject.state).to eq(
        'UF UR UB UL FL FR BR BL DL DF DR DB UFL URF UBR ULB DBL DLF DFR DRB'
      )
    end
  end

  describe '#f' do
    it 'turns the front face 90 degrees clockwise' do
      subject.f

      expect(subject.state).to eq(
        'LF UR UB UL FD FU BR BL RF DR DB DL LFD LUF UBR ULB RDF RFU DRB DBL'
      )
    end
  end

  describe '#b' do
    it 'turns the back face 90 degrees clockwise' do
      subject.b

      expect(subject.state).to eq(
        'UF UR RB UL FL FR BD BU DF DR LB DL UFL URF RBD RUB DLF DFR LDB LBU'
      )
    end
  end

  describe '#m' do
    it 'turns the middle slice 90 degrees clockwise (from L)' do
      subject.m

      expect(subject.state).to eq(
        'BU UR BD UL FL FR BR BL FU DR FD DL UFL URF UBR ULB DLF DFR DRB DBL'
      )
    end
  end
end
