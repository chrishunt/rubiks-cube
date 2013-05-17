require 'spec_helper'

describe RubiksCube::Cube do
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
        expect(subject.state).to eq RubiksCube::Cube::SOLVED_STATE.join ' '
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
        subject.state.split[0..11].map { |cubie| RubiksCube::Cubie.new cubie }
      )
    end
  end

  describe '#corners' do
    it 'returns all the corners' do
      expect(subject.corners).to eq(
        subject.state.split[12..-1].map { |cubie| RubiksCube::Cubie.new cubie }
      )
    end
  end

  describe '#incorrect_edge_permutation_locations' do
    context 'with unpermuted edges' do
      let(:state) {
        'UF UL UB UR FL FR BR BL DF DL DB DR UFL URF UBR ULB DLF DFR DRB DBL'
      }

      it 'returns the location of all unpermuted edges' do
        expect(
          subject.incorrect_edge_permutation_locations
        ).to eq [1, 3, 9, 11]
      end
    end

    context 'with permuted edges' do
      it 'returns an empty array' do
        expect(subject.incorrect_edge_permutation_locations).to eq []
      end
    end
  end

  describe '#incorrect_corner_permutation_locations' do
    context 'with unpermuted corners' do
      let(:state){
        'UF UR UB UL FL FR BR BL DF DR DB DL ULB UBR URF UFL DLF DFR DRB DBL'
      }

      it 'returns the locations of all unpermuted corners' do
        expect(
          subject.incorrect_corner_permutation_locations
        ).to eq [0, 1, 2, 3]
      end
    end

    context 'with permuted corners' do
      it 'returns an empty array' do
        expect(subject.incorrect_corner_permutation_locations).to eq []
      end
    end
  end

  describe '#incorrect_edge_orientation_locations' do
    context 'with edges that are not oriented' do
      let(:state) {
        'FU UR BU UL FL RF RB LB FD DR DB DL UFL URF UBR ULB DLF DFR DRB DBL'
      }

      it 'returns the locations of all unoriented edges' do
        expect(
          subject.incorrect_edge_orientation_locations
        ).to eq [0, 2, 5, 6, 7, 8]
      end
    end

    context 'with oriented edges' do
      it 'returns an empty array' do
        expect(subject.incorrect_edge_orientation_locations).to eq []
      end
    end
  end

  describe '#incorrect_corner_orientation_locations' do
    context 'with corners that are not oriented' do
      let(:state) {
        'UF UR UB UL FL FR BR BL DF DR DB DL FLU FUR UBR ULB DLF DFR DRB DBL'
      }

      it 'returns the locations of all unoriented corners' do
        expect(subject.incorrect_corner_orientation_locations).to eq [0, 1]
      end
    end

    context 'with oriented corners' do
      it 'returns an empty array' do
        expect(subject.incorrect_corner_orientation_locations).to eq []
      end
    end
  end

  describe '#permuted_location_for' do
    RubiksCube::Cube::SOLVED_STATE.each_with_index do |cubie, location|
      it "returns the correct location for the '#{cubie}' cubie" do
        # Both corner and edge index begins at zero
        location -= 12 if location >= 12

        cubie = RubiksCube::Cubie.new cubie

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

  describe '#has_correct_edge_permutation?' do
    context 'when the edges are permuted, but corners are not' do
      let(:state) {
        'UF UR UB UL FL FR BR BL DF DR DB DL ULB UBR URF UFL DBL DRB DFR DLF'
      }

      it 'returns true' do
        expect(subject).to have_correct_edge_permutation
      end
    end

    context 'when the edges are not permuted, but corners are' do
      let(:state) {
        'UL UF UB UR FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL'
      }

      it 'returns false' do
        expect(subject).to_not have_correct_edge_permutation
      end
    end
  end

  describe '#has_correct_corner_permutation?' do
    context 'when the corners are permuted, but the edges are not' do
      let(:state) {
        'UL UF UB UR FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL'
      }

      it 'returns true' do
        expect(subject).to have_correct_corner_permutation
      end
    end

    context 'when the corners are not permuted, but the edges are permuted' do
      let(:state) {
        'UF UR UB UL FL FR BR BL DF DR DB DL ULB UBR URF UFL DBL DRB DFR DLF'
      }

      it 'returns false' do
        expect(subject).to_not have_correct_corner_permutation
      end
    end
  end

  describe '#has_correct_edge_orientation?' do
    context 'when the edges are oriented, but the corners are not' do
      let(:state) {
        'UF UR UB UL FL FR BR BL DF DR DB DL LUF RFU UBR ULB DLF DFR DRB DBL'
      }

      it 'returns true' do
        expect(subject).to have_correct_edge_orientation
      end
    end

    context 'when the edges are not oriented, but the corners are' do
      let(:state) {
        'FU UR BU UL FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL'
      }

      it 'returns false' do
        expect(subject).to_not have_correct_edge_orientation
      end
    end
  end

  describe '#has_correct_corner_orientation?' do
    context 'when the corners are oriented, but the edges are not' do
      let(:state) {
        'FU UR BU UL FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL'
      }

      it 'returns true' do
        expect(subject).to have_correct_corner_orientation
      end
    end

    context 'when the corners are not oriented, but the edges are' do
      let(:state) {
        'UF UR UB UL FL FR BR BL DF DR DB DL LUF RFU UBR ULB DLF DFR DRB DBL'
      }

      it 'returns false' do
        expect(subject).to_not have_correct_corner_orientation
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

  describe 'face turns' do
    shared_examples_for 'a face turn' do
      it "rotates the face 90 degrees clockwise" do
        subject.public_send direction
        expect(subject.state).to eq expected_state
      end

      it 'is chainable' do
        expect(subject.public_send direction).to eq subject
      end
    end

    describe '#r' do
      let(:direction) { 'r' }
      let(:expected_state) {
        'UF FR UB UL FL DR UR BL DF BR DB DL UFL FRD FUR ULB DLF BDR BRU DBL'
      }

      it_should_behave_like 'a face turn'
    end

    describe '#l' do
      let(:direction) { 'l' }
      let(:expected_state) {
        'UF UR UB BL UL FR BR DL DF DR DB FL BUL URF UBR BLD FLU DFR DRB FDL'
      }

      it_should_behave_like 'a face turn'
    end

    describe '#u' do
      let(:direction) { 'u' }
      let(:expected_state) {
        'UR UB UL UF FL FR BR BL DF DR DB DL URF UBR ULB UFL DLF DFR DRB DBL'
      }

      it_should_behave_like 'a face turn'
    end

    describe '#d' do
      let(:direction) { 'd' }
      let(:expected_state) {
        'UF UR UB UL FL FR BR BL DL DF DR DB UFL URF UBR ULB DBL DLF DFR DRB'
      }

      it_should_behave_like 'a face turn'
    end

    describe '#f' do
      let(:direction) { 'f' }
      let(:expected_state) {
        'LF UR UB UL FD FU BR BL RF DR DB DL LFD LUF UBR ULB RDF RFU DRB DBL'
      }

      it_should_behave_like 'a face turn'
    end

    describe '#b' do
      let(:direction) { 'b' }
      let(:expected_state) {
        'UF UR RB UL FL FR BD BU DF DR LB DL UFL URF RBD RUB DLF DFR LDB LBU'
      }

      it_should_behave_like 'a face turn'
    end

    describe '#m' do
      let(:direction) { 'm' }
      let(:expected_state) {
        'BU UR BD UL FL FR BR BL FU DR FD DL UFL URF UBR ULB DLF DFR DRB DBL'
      }

      it_should_behave_like 'a face turn'
    end
  end
end
