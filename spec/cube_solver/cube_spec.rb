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

  describe '#unsolved_edge_locations' do
    context 'with unsolved edges' do
      let(:state) {
        'UF UL UB UR FL FR BR BL DF DL DB DR UFL URF UBR ULB DLF DFR DRB DBL'
      }

      it 'returns the location of all unsolved edges' do
        expect(subject.unsolved_edge_locations).to eq [1, 3, 9, 11]
      end
    end

    context 'with solved edges' do
      it 'returns an empty array' do
        expect(subject.unsolved_edge_locations).to eq []
      end
    end
  end

  describe '#unsolved_corner_locations' do
    context 'with unsolved corners' do
      let(:state){
        'UF UR UB UL FL FR BR BL DF DR DB DL ULB UBR URF UFL DLF DFR DRB DBL'
      }

      it 'returns the locations of all unsolved corners' do
        expect(subject.unsolved_corner_locations).to eq [0, 1, 2, 3]
      end
    end

    context 'with solved corners' do
      it 'returns an empty array' do
        expect(subject.unsolved_corner_locations).to eq []
      end
    end
  end

  describe '#solved_location_for' do
    CubeSolver::Cube::SOLVED_STATE.each_with_index do |cubie, location|
      it "returns the correct location for the '#{cubie}' cubie" do
        # Both corner and edge index begins at zero
        location -= 12 if location >= 12

        cubie = CubeSolver::Cubie.new cubie

        expect(subject.solved_location_for cubie).to eq location
      end
    end

    context 'when the cubie has been rotated' do
      let(:cubie) { subject.corners.first }

      before { cubie.rotate! }

      it 'still finds the correct location' do
        expect(subject.solved_location_for cubie).to eq 0
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

  describe '#edge_solved?' do
    it 'returns true when the cubie is solved' do
      subject.u

      solved_edge = subject.edges[4]
      unsolved_edge = subject.edges[0]

      expect(subject.edge_solved? unsolved_edge).to be_false
      expect(subject.edge_solved? solved_edge).to be_true
    end
  end

  describe '#corner_solved?' do
    it 'returns true when the cubie is solved' do
      subject.f

      solved_corner = subject.corners[2]
      unsolved_corner = subject.corners[1]

      expect(subject.corner_solved? unsolved_corner).to be_false
      expect(subject.corner_solved? solved_corner).to be_true
    end
  end

  describe '#has_edges_solved?' do
    context 'when the edges are solved, but corners are not' do
      let(:state) {
        'UF UR UB UL FL FR BR BL DF DR DB DL ULB UBR URF UFL DBL DRB DFR DLF'
      }

      it 'returns true' do
        expect(subject).to have_edges_solved
      end
    end

    context 'when the edges are not solved, but corners are' do
      let(:state) {
        'UL UF UB UR FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL'
      }

      it 'returns false' do
        expect(subject).to_not have_edges_solved
      end
    end
  end

  describe '#has_corners_solved?' do
    context 'when the corners are solved, but the edges are not' do
      let(:state) {
        'UL UF UB UR FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL'
      }

      it 'returns true' do
        expect(subject).to have_corners_solved
      end
    end

    context 'when the corners are not solved, but the edges are solved' do
      let(:state) {
        'UF UR UB UL FL FR BR BL DF DR DB DL ULB UBR URF UFL DBL DRB DFR DLF'
      }

      it 'returns false' do
        expect(subject).to_not have_corners_solved
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
end
