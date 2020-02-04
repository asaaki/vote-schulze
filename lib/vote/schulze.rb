# frozen_string_literal: true

require 'vote/matrix'
require 'vote/schulze/input'
require 'vote/schulze/basic'

module Vote
  # Consult README.md for usage
  module Schulze
    # Shortcut to Vote::Schulze::Basic.call(...)
    def self.basic(*arguments)
      Basic.call(*arguments)
    end
  end
end
