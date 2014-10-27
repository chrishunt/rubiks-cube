require 'spec_helper'

describe RubiksCube::StickerStateTransform do
  subject { described_class.new state }

  let(:state) { nil }

  describe '#to_cube' do
    context 'when initialized with sticker state' do
      let(:state) {[
        "g b b b w b o g b \

         o w b o o g r r w r y y o y r r g o r w o y r w",
        "gw  bg      o yggowywyywrbbyrg  "
      ].join(' ')}

      it 'transforms to cube state' do
        expect(subject.to_cube).to eq(
          "BD RF RB UF DF DR RU LB BU DL LU LF FUR FRD BLD ULB BDR FDL UFL BRU"
        )
      end
    end

    context "for a solved cube" do
      let(:state) { <<-STATE }
        BBB BBB BBB WWW WWW WWW RRR RRR RRR YYY YYY YYY OOO OOO OOO GGG GGG GGG
      STATE

      it 'transforms to cube state' do
        expect(subject.to_cube).to eq(
          "UF UR UB UL FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL"
        )
      end
    end

    context 'for an example with a few scrambled faces' do
      let(:state) { <<-STATE }
        GGY GGR GGG RRY YYY YYY WWW WWW WWB BBB BBB OBB RRR RRG RYG OOO OOO WOO
      STATE

      it 'transforms to cube state' do
        expect(subject.to_cube).to eq(
          "RF FU UB UL FL UR BR BL DF DR DB DL UFL FUR UBR ULB DLF DFR DRB BLD"
        )
      end
    end

    context 'with too few letters' do
      let(:state) {
        'GGY GGR GGG RRY YYY YYY WW WWW WWB BBB BBB OBB RRR RRG RYG OOO OOO WOO'
      }

      it 'throws an exception' do
        expect {
          subject.to_cube
        }.to raise_error('too few stickers')
      end
    end

    context 'with too many letters' do
      let(:state) { <<-STATE }
        GGY GGR GGG RRY YYY YYY WWWW WWW WWB BBB BBB OBB RRR RRG RYG OOO OOO WOO
      STATE

      it 'throws an exception' do
        expect {
          subject.to_cube
        }.to raise_error('too many stickers')
      end
    end

    context 'two center faces are identical' do
      let(:state) { <<-STATE }
        BBB BBB BBB WWW WBW WWW RRR RRR RRR YYY YYY YYY OOO OOO OOO GGG GGG GGG
      STATE

      it 'throws an exception' do
        expect {
          subject.to_cube
        }.to raise_error('B is listed in the center twice')
      end
    end

    context 'with a color not in a center face' do
      let(:state) { <<-STATE }
        PBB BBB BBB WWW WWW WWW RRR RRR RRR YYY YYY YYY OOO OOO OOO GGG GGG GGG
      STATE

      it 'throws an exception' do
        expect {
          subject.to_cube
        }.to raise_error('P is not listed in the center anywhere')
      end
    end
  end
end
