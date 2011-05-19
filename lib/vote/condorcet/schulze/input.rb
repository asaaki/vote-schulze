# encoding: UTF-8

module Vote
  module Condorcet
    module Schulze

      class Input

        @vote_matrix = nil

        def initialize candidate_count, vote_list
          @vote_matrix = ::Matrix.scalar(candidate_count,0).extend(Vote::Matrix)
          insert_vote_array(vote_list) if vote_list.is_a?(Array)
          insert_vote_file(vote_list) if vote_list.is_a?(File)
        end

        def insert_vote_array va
          va.each do |vote|
            @vote_matrix.each_with_index do |e,x,y|
              next if x==y
              @vote_matrix[x,y] += 1 if vote[x]>vote[y]
            end
          end
        end

        def insert_vote_list vl
          #...
        end

        def insert_vote_file vf
          #...
        end

        def matrix
          @vote_matrix
        end

      end

    end
  end
end

