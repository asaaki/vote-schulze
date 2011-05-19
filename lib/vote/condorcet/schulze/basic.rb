# encoding: UTF-8

module Vote
  module Condorcet
    module Schulze

      class Basic

        def initialize
          #self
        end

        def load candidate_count, vote_matrix

          @candidate_count = candidate_count

          @vote_matrix = vote_matrix.is_a?(Vote::Condorcet::Schulze::Input) ? \
            vote_matrix.matrix : \
            Vote::Condorcet::Schulze::Input.new(
              candidate_count,
              vote_matrix
            ).matrix

          self
        end

        private

        def play

          @play_matrix = ::Matrix.scalar(@candidate_count,0).extend(Vote::Matrix)

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

          self
        end


        def result

          @result_matrix = ::Matrix.scalar(@candidate_count,0).extend(Vote::Matrix)

          @result_matrix.each_with_index do |e,x,y|
            next if x==y
            @result_matrix[x,y] = e+1 if @play_matrix[x,y] > @play_matrix[y,x]
          end

          self
        end


        def rank

          @ranking = Array.new(@candidate_count,0)

          @result_matrix.row_vectors.each_with_index do |v,i|
            v.to_a.map do |e|
              @ranking[i] += e
            end
          end

          self
        end

        public

        def run
          play
          result
          rank
        end

        def vote_matrix
          @vote_matrix
        end
        def play_matrix
          @play_matrix
        end
        def result_matrix
          @result_matrix
        end
        def ranking_array
          @ranking
        end


        # All-in-One class method to get a calculated SchulzeBasic object
        def self.do candidate_count, vote_matrix
          instance = new
          instance.load candidate_count, vote_matrix
          instance.run
          instance
        end

      end #Basic

    end #Schulze
  end #Condorcet
end #Vote

