# frozen_string_literal: true

require 'matrix'

# extend matrix with method []=(i, j, v)
# usage: m = ::Matrix.scalar(size, value).extend(Vote::Matrix)
module Vote
  module Matrix
    def []=(i, j, v) # rubocop:disable Naming/MethodParameterName
      @rows[i][j] = v
    end
  end
end
