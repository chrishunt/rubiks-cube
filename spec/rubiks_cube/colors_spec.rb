#encoding: utf-8
require 'spec_helper'

describe RubiksCube::Colors do
  describe '.by_face' do
    # U;F;R;B;L;D

    subject { described_class.by_face colors }

    context 'for a solved cube' do
      let(:colors) {
        'BBB,BBB,BBB;WWW,WWW,WWW;RRR,RRR,RRR;YYY,YYY,YYY;OOO,OOO,OOO;GGG,GGG,GGG'
      }

      it "reads it in" do
        expect(subject).to be_solved
        expect(subject.state).to eq(
          "UF UR UB UL FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL"
        )
      end
    end

    context 'for an example with a few scrambled faces' do
      let(:colors) {
        'RRR,RRG,RYG;GGY,GGR,GGG;RRY,YYY,YYY;WWW,WWW,WWB;BBB,BBB,OBB;OOO,OOO,WOO'
      }

      it "comes up with the right state" do
        expect(subject.state).to eq(
          "RF FU UB UL FL UR BR BL DF DR DB DL UFL FUR UBR ULB DLF DFR DRB BLD"
        )
      end
    end

    context 'when the number of squares in a row is not 3' do
      let(:colors) {
        'RRR,RRG,RYG;GGY,GR,GGG;RRY,YYY,YYY;WWW,WWW,WWB;BBB,BBB,OBB;OOO,OOO,WOO'
      }

      it 'throws an exception' do
        expect {
          subject
        }.to raise_error('GR is not three characters')
      end
    end

    context 'when the number of rows is not 3' do
      let(:colors) {
        'RRR,RRG,RYG;GGY,GGR,GGG,OOO;RRY,YYY,YYY;WWW,WWW,WWB;BBB,BBB,OBB;OOO,OOO,WOO'
      }

      it 'throws an exception' do
        expect {
          subject
        }.to raise_error('GGY,GGR,GGG,OOO is not three rows')
      end
    end

    context 'when the number of faces is not 6' do
      let(:colors) {
        'RRR,RRG,RYG;GGY,GGR,GGG;WWW,WWW,WWB;BBB,BBB,OBB;OOO,OOO,WOO'
      }

      it 'throws an exception' do
        expect {
          subject
        }.to raise_error('number of faces is not six')
      end
    end

    context 'two center faces are identical' do
      let(:colors) {
        'BBB,BBB,BBB;WWW,WBW,WWW;RRR,RRR,RRR;YYY,YYY,YYY;OOO,OOO,OOO;GGG,GGG,GGG'
      }

      it 'throws an exception' do
        expect {
          subject
        }.to raise_error('B is listed in the center twice')
      end
    end

    context 'with a color not in a center face' do
      let(:colors) {
        'PBB,BBB,BBB;WWW,WWW,WWW;RRR,RRR,RRR;YYY,YYY,YYY;OOO,OOO,OOO;GGG,GGG,GGG'
      }

      it 'throws an exception' do
        expect {
          subject
        }.to raise_error('P is not listed in the center anywhere')
      end
    end
  end

  describe "#to_h" do
    subject { RubiksCube::Colors.new(colors).to_h }
    context 'with a bunch of values' do
      # Of course, a real cube wouldn't have 54 colors like this, but this is easier
      # for testing #to_h
      let(:colors) {
        'abc,def,ghi;ABC,DEF,GHI;αβγ,δεζ,ηθἱ;БГД,ЖИЛ,ПҀȢ;jkl,mno,pqr;ΓΔΘ,ΞΣΦ,ΨΩΛ'
      }

      it "lets you get them" do
        expect(subject[:up][0]).to eq(['a', 'b', 'c'])
        expect(subject[:up][1]).to eq(['d', 'e', 'f'])
        expect(subject[:up][2]).to eq(['g', 'h', 'i'])

        expect(subject[:front][0]).to eq(['A', 'B', 'C'])

        expect([:right, :back, :left, :down].map { |direction| subject[direction][0][0] }).
          to eq(['α', 'Б', 'j', 'Γ'])
      end

    end

  end

  describe "#color_to_face" do
    subject { RubiksCube::Colors.new(colors).color_to_face }
    let(:colors) {
      'RRR,RRG,RYG;GGY,GGR,GGG;RRY,YYY,YYY;WWW,WWW,WWB;BBB,BBB,WBB;OOO,OOO,OOW'
    }
    it "should map from a color to the face" do
      expect(subject).to eq({'R' => 'U', 'G' => 'F', 'Y' => 'R',
        'W' => 'B', 'B' => 'L', 'O' => 'D'})
    end 
  end

  describe "#to_face" do
    subject { RubiksCube::Colors.new(colors) }
    let(:colors) {
      'RRR,RRG,RYG;GGY,GGR,GGG;RRY,YYY,YYY;WWW,WWW,WWB;BBB,BBB,WBB;OOO,OOO,OOW'
    }

    it "can tell you which face a given color is on" do
      expect(subject.to_face 'R').to eq('U')
      expect(subject.to_face 'G').to eq('F')
      expect(subject.to_face 'Y').to eq('R')
    end
  end

  describe "#to_state" do
    subject { RubiksCube::Colors.new(colors).to_state }

    context 'for a slightly scrambled example' do
      let(:colors) {
        'RRR,RRG,RYG;GGY,GGR,GGG;RRY,YYY,YYY;WWW,WWW,WWB;BBB,BBB,OBB;OOO,OOO,WOO'
      }

      it "comes up with the right state" do
        expect(subject).to eq(
          "RF FU UB UL FL UR BR BL DF DR DB DL UFL FUR UBR ULB DLF DFR DRB BLD"
        )
      end
    end
  end
end

