module Vote
  module Condorcet
    module Schulze
      class Basic
        def load vote_matrix, candidate_count=nil
          input = if vote_matrix.is_a?(Vote::Condorcet::Schulze::Input)
                    vote_matrix
                  else
                    Vote::Condorcet::Schulze::Input.new(
                        vote_matrix,
                        candidate_count
                    )
                  end
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
            @result_matrix[x, y] = e + 1 if @play_matrix[x, y] > @play_matrix[y, x]
          end
        end

        def calculate_winners
          @winners_array = Array.new(@candidate_count, 0)
          @winners_array.each_with_index do |el, idx|
            unless @play_matrix.row(idx).any? { |r| @play_matrix.column(idx).any? { |v| v > r } }
              @winners_array[idx] = 1
            end
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
            [e, self.class.idx_to_chr(r.index(e))] # => [int,letter]
          }.
              sort.reverse.# bring in correct order
          map { |e| "#{e[1]}:#{rmax - e[0] + 1}" } # => "letter:int"
          @ranking_abc = abc
        end

        def calculate_classifications
          potentials = []
          ranks = @ranking
          ranks.each_with_index do |val, idx|
            if val > 0
              potentials << idx
            end
          end

          beated = []
          ranks.each_with_index do |val, idx|
            ranks.each_with_index do |val2, idx2|
              next if idx == idx2
              if @play_matrix[idx, idx2] > @play_matrix[idx2, idx]
                beated << [idx2, idx]
              end
            end
          end

          permutations = (0..ranks.length-1).to_a.permutation

          classifications = permutations.map do |array|
            next unless potentials.include? array[0]
            next unless beated.all? { |couple| array.index(couple[0]) > array.index(couple[1]) }
            array
          end

          @classifications = classifications.compact
        end


        public

        def self.idx_to_chr(idx)
          (idx + 65).chr
        end

        def run
          play
          result
          calculate_winners
          rank
          rank_abc
          calculate_classifications
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

        # return all possible solutions to the votation
        def winners_array
          @winners_array
        end

        def classifications
          @classifications
        end

        # All-in-One class method to get a calculated SchulzeBasic object
        def self.do vote_matrix, candidate_count=nil
          instance = new
          instance.load vote_matrix, candidate_count
          instance.run
          instance
        end
      end
    end
  end
end
