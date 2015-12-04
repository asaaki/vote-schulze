# encoding: UTF-8

# extend matrix with method []=(i,j,v)
# usage: m = ::Matrix.scalar(size,value).extend(Vote::Matrix)

module Vote
  module Matrix
    def []=(i, j, v)
      @rows[i][j] = v
    end
  end
end

