# encoding: UTF-8

module Vote
  module Condorcet
    module Schulze
      class Basic
        def load vote_matrix, candidate_count=nil
          input = vote_matrix.is_a?(Vote::Condorcet::Schulze::Input) ? \
            vote_matrix : \
            Vote::Condorcet::Schulze::Input.new(
              vote_matrix,
              candidate_count
          )
          @vote_matrix = input.matrix
          @candidate_count = input.candidates
          @vote_count = input.voters
          self
        end

        private

        def play
          @play_matrix = ::Matrix.scalar(@candidate_count, 0).extend(Vote::Matrix)
          # step 1: find matches with wins
          @candidate_count.times do |i|
            @candidate_count.times do |j|
              next if i == j
              if @vote_matrix[i, j] > @vote_matrix[j, i]
                @play_matrix[i, j] = @vote_matrix[i, j]
              else
                @play_matrix[i, j] = 0
              end
            end
          end

          #step 2: find strongest paths
          @candidate_count.times do |i|
            @candidate_count.times do |j|
              next if i == j
              @candidate_count.times do |k|
                next if (i == k) || (j == k)
                @play_matrix[j, k] = [
                    @play_matrix[j, k],
                    [@play_matrix[j, i], @play_matrix[i, k]].min
                ].max
              end
            end
          end
        end

        def result
          @result_matrix = ::Matrix.scalar(@candidate_count, 0).extend(Vote::Matrix)
          @result_matrix.each_with_index do |e, x, y|
            next if x == y
            @result_matrix[x, y] = e+1 if @play_matrix[x, y] > @play_matrix[y, x]
          end
        end

        def rank
          @ranking = @result_matrix.
              row_vectors.map { |e| e.inject(0) { |s, v| s += v } }
        end

        def rank_abc
          r = @ranking
          rmax = r.max
          abc = r.map { |e|
            [e, (r.index(e)+65).chr] # => [int,letter]
          }.
              sort.reverse.# bring in correct order
          map { |e| "#{e[1]}:#{rmax-e[0]+1}" } # => "letter:int"
          @ranking_abc = abc
        end


        public

        def run
          play
          result
          rank
          rank_abc
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

        def ranks
          @ranking
        end

        def ranks_abc
          @ranking_abc
        end

        def voters
          @vote_count
        end

        # All-in-One class method to get a calculated SchulzeBasic object
        def self.do vote_matrix, candidate_count=nil
          instance = new
          instance.load vote_matrix, candidate_count
          instance.run
          instance
        end

      end #Basic

    end #Schulze
  end #Condorcet
end #Vote

