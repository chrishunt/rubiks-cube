module RubiksCube
  # Transform manual sticker state entry to cube state
  class StickerStateTransform
    attr_reader :state

    CENTER_LOCATIONS = [ 4, 13, 22, 31, 40, 49 ]

    CORNER_LOCATIONS = [
      42, 0 , 29, 44, 9, 2 , 38, 18, 11, 36, 27, 20,
      45, 35, 6 , 47, 8, 15, 53, 17, 24, 51, 26, 33
    ]

    EDGE_LOCATIONS = [
      43, 1 , 41, 10, 37, 19, 39, 28,
      3 , 32, 5 , 12, 21, 14, 23, 30,
      46, 7 , 50, 16, 52, 25, 48, 34
    ]

    def initialize(state)
      @state = state.gsub(/\s/, '').split('')
    end

    def to_cube
      (edges + corners).join(' ').gsub(/./) { |c| color_mapping.fetch(c, c) }
    end

    private

    def color_mapping
      Hash[state.values_at(*CENTER_LOCATIONS).zip %w(F R B L U D)]
    end

    def edges
      state.values_at(*EDGE_LOCATIONS).each_slice(2).map(&:join)
    end

    def corners
      state.values_at(*CORNER_LOCATIONS).each_slice(3).map(&:join)
    end
  end
end
