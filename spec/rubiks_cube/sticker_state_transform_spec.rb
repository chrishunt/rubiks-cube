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
  end
end
