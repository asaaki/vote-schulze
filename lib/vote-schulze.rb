# encoding: UTF-8

# $:<<`pwd`.strip
# require 'vote-schulze'

require 'matrix'
require 'vote'
require 'vote/matrix'

autoload :Vote, 'vote'

SchulzeInput = Vote::Condorcet::Schulze::Input
SchulzeBasic = Vote::Condorcet::Schulze::Basic
SchulzeWinAndLost = Vote::Condorcet::Schulze::WinAndLost

