# encoding: UTF-8
# monkey patch for public element modification
class Matrix
  def []=(i,j,v)
    @rows[i][j] = v
  end
end

