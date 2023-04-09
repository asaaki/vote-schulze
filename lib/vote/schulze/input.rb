# frozen_string_literal: true

module Vote
  module Schulze
    class Input
      attr_reader :candidate_count, :voting_count, :voting_matrix

      def initialize(voting_data, candidate_count = nil)
        @voting_data = voting_data
        @candidate_count = candidate_count

        if @candidate_count.nil?
          insert_voting_file(@voting_data) if voting_data.is_a?(File)
        else
          @voting_matrix = ::Matrix.scalar(@candidate_count, 0).extend(Vote::Matrix)
          insert_voting_array(@voting_data) if voting_data.is_a?(Array)
          insert_voting_string(@voting_data) if voting_data.is_a?(String)
        end
      end

      def insert_voting_array(voting_array)
        voting_array.each do |vote|
          @voting_matrix.each_with_index do |_e, x, y|
            next if x == y

            @voting_matrix[x, y] += 1 if vote[x] > vote[y]
          end
        end
        @voting_count = voting_array.size
      end

      def insert_voting_string(voting_string) # rubocop:todo all
        voting_array = []
        voting_string.split(/\n|\n\r|\r/).each do |voter|
          voter = voter.split('=')
          vcount = voter.size == 1 ? 1 : voter[0].to_i

          tmp = voter.last.split(';')
          tmp2 = []

          tmp.map! { |e| [e, @candidate_count - tmp.index(e)] }
          # find equal-weighted candidates
          tmp.map do |e|
            if e[0].size > 1
              e[0].split(',').each do |f|
                tmp2 << [f, e[1]]
              end
            else
              tmp2 << e
            end
          end

          vote = tmp2.sort.map { |e| e[1] } # order, strip & add
          vcount.times do
            voting_array << vote
          end
        end

        insert_voting_array(voting_array)
      end

      def insert_voting_file(voting_file)
        voting_file.rewind
        @candidate_count = voting_file.first.strip.to_i # reads first line for count
        @voting_matrix = ::Matrix.scalar(@candidate_count, 0).extend(Vote::Matrix)
        insert_voting_string(voting_file.read) # reads rest of file (w/o line 1)
        voting_file.close
      end
    end
  end
end
