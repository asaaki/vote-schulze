# encoding: UTF-8
module Vote
  module Condorcet
    module Schulze
      autoload :Input, 'vote/condorcet/schulze/input'
      autoload :Basic, 'vote/condorcet/schulze/basic'
      autoload :WinAndLost, 'vote/condorcet/schulze/win_and_lost'
    end
  end
end

