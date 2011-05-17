# encoding: UTF-8
require 'matrix'

module Vote
  module Condorcet
    module Schulze

      class Basic
        @candidate_count = 0
        @vote_matrix = nil
        @play_matrix = nil
        @result_matrix = nil
        @ranking = nil

        def initialize candidate_count=0, vote_matrix=nil
          if candidate_count > 0 && vote_matrix != nil
            load
          end
          true
        end

        def load candidate_count, vote_matrix

          @play_matrix = nil
          @result_matrix = nil
          @ranking = nil

          @candidate_count = candidate_count

          @vote_matrix = vote_matrix.is_a?(Vote::Condorcet::Schulze::Input) ? \
            vote_matrix.matrix : \
            Vote::Condorcet::Schulze::Input.new(
              candidate_count,
              vote_matrix
            ).matrix

          self
        end

        def vote_matrix
          @vote_matrix
        end

        def play

          @play_matrix ||= Matrix.scalar(@candidate_count,0)

          # step 1: find matches with wins
          @candidate_count.times do |i|
            @candidate_count.times do |j|
              next if i==j
              if @vote_matrix[i,j] > @vote_matrix[j,i]
                @play_matrix[i,j] = @vote_matrix[i,j]
              end
            end
          end

          #step 2: find strongest pathes
          @candidate_count.times do |i|
            @candidate_count.times do |j|
              next if i==j
              @candidate_count.times do |k|
                next if i==k
                next if j==k
                @play_matrix[j,k] = [
                  @play_matrix[j,k],
                  [ @play_matrix[j,i], @play_matrix[i,k] ].min
                  ].max
              end
            end
          end

          true
        end

        def play_matrix
          @play_matrix
        end

        def result
          @result_matrix ||= Matrix.scalar(@candidate_count,0)

          @result_matrix.each_with_index do |e,x,y|
            next if x==y
            @result_matrix[x,y] = e+1 if @play_matrix[x,y] > @play_matrix[y,x]
          end

          true
        end

        def result_matrix
          @result_matrix
        end

        def rank

          @ranking ||= Array.new(@candidate_count,0)

          @result_matrix.row_vectors.each_with_index do |v,i|
            v.to_a.map do |e|
              @ranking[i] += e
            end
          end

          true
        end

        def ranking_array
          @ranking
        end

        def run
          play
          result
          rank
          @ranking
        end

      end

    end
  end
end

