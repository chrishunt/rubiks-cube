module RubiksCube
  class Colors
    DIRECTIONS = %i{up front right back left down}

    # Return a RubiksCube::Cube given colors for each face.
    # Each face is a list of three rows (top to bottom). Each row contains three
    # characters for the colors of the face (left to right). Rows are separated
    # by commas and faces are separated by semicolons. The faces
    # are in the order up, front, right, back, left, and down.
    # For example, a solved cube might be created by:
    # BBB,BBB,BBB;WWW,WWW,WWW;RRR,RRR,RRR;YYY,YYY,YYY;OOO,OOO,OOO;GGG,GGG,GGG
    def self.by_face(colors)
      Cube.new Colors.new(colors).to_state
    end

    attr_reader :colors

    def initialize(colors)
      @colors = colors
    end

    def to_h
      @hash ||= Hash[DIRECTIONS.zip(cells_by_line_by_face)]
    end

    def cells_by_line_by_face
      lines_by_face.map { |face| face.map { |line| line_to_array(line) } }
    end

    def line_to_array(line)
      if line.length != 3
        raise "#{line} is not three characters"
      end
      line.split('')
    end

    def lines_by_face
      faces.map { |face| face_to_array(face) }
    end

    def face_to_array(face)
      array = face.split(',')
      if array.length != 3
        raise "#{face} is not three rows"
      end
      array
    end

    def faces
      array = colors.split(';')
      if array.length != 6
        raise "number of faces is not six"
      end
      array
    end

    def color_to_face
      @color_to_face ||= DIRECTIONS.each_with_object({}) do |direction, hash|
        center = to_h[direction][1][1] 
        if hash[center]
          raise "#{center} is listed in the center twice"
        end
        hash[center] = direction.to_s[0].upcase
      end
    end

    def to_face(color)
      color_to_face[color] or raise "#{color} is not listed in the center anywhere"
    end

    def to_state
      [
        # edges, top tier
        [[:up, 2, 1], [:front, 0, 1]],
        [[:up, 1, 2], [:right, 0, 1]],
        [[:up, 0, 1], [:back, 0, 1]],
        [[:up, 1, 0], [:left, 0, 1]],

        # edges, middle tier
        [[:front, 1, 0], [:left, 1, 2]],
        [[:front, 1, 2], [:right, 1, 0]],
        [[:back, 1, 0], [:right, 1, 2]],
        [[:back, 1, 2], [:left, 1, 0]],

        # edges, bottom tier
        [[:down, 0, 1], [:front, 2, 1]],
        [[:down, 1, 2], [:right, 2, 1]],
        [[:down, 2, 1], [:back, 2, 1]],
        [[:down, 1, 0], [:left, 2, 1]],

        # corners, top tier
        [[:up, 2, 0], [:front, 0, 0], [:left, 0, 2]],
        [[:up, 2, 2], [:right, 0, 0], [:front, 0, 2]],
        [[:up, 0, 2], [:back, 0, 0], [:right, 0, 2]],
        [[:up, 0, 0], [:left, 0, 0], [:back, 0, 2]],

        # corners, bottom tier
        [[:down, 0, 0], [:left, 2, 2], [:front, 2, 0]],
        [[:down, 0, 2], [:front, 2, 2], [:right, 2, 0]],
        [[:down, 2, 2], [:right, 2, 2], [:back, 2, 0]],
        [[:down, 2, 0], [:back, 2, 2], [:left, 2, 0]]
      ].map do |cubelet|
        cubelet.map do |face, row, column|
          to_face(to_h[face][row][column])
        end.join('')
      end.join(' ')
    end
  end
end
