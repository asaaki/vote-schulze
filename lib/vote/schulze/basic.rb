# frozen_string_literal: true

module Vote
  module Schulze
    class Basic
      # All-in-One class method to get a calculated SchulzeBasic object
      def self.call(voting_data, candidate_count = nil)
        new(voting_data, candidate_count).call
      end

      attr_reader :voting_matrix, :play_matrix, :result_matrix,
                  :ranking, :ranking_abc, :candidate_count, :voting_count,
                  :candidate_names, :votes

      def initialize(voting_data, candidate_count = nil)
        unless voting_data.is_a?(Vote::Schulze::Input)
          voting_data = Vote::Schulze::Input.new(voting_data, candidate_count)
        end
        @voting_matrix = voting_data.voting_matrix
        @candidate_count = voting_data.candidate_count
        @voting_count = voting_data.voting_count
        @candidate_names = voting_data.candidate_names
        @votes = voting_data.votes
        @play_matrix = ::Matrix.scalar(@candidate_count, 0).extend(Vote::Matrix)
        @result_matrix = ::Matrix.scalar(@candidate_count, 0).extend(Vote::Matrix)
      end

      def call
        tap do
          find_matches_with_wins
          find_strongest_paths
          calculate_result
          calculate_ranking
          calculate_ranking_abc
        end
      end

      private

      def find_matches_with_wins
        @candidate_count.times do |i|
          @candidate_count.times do |j|
            next if i == j

            @play_matrix[i, j] = @voting_matrix[i, j] if @voting_matrix[i, j] > @voting_matrix[j, i]
          end
        end
      end

      def find_strongest_paths # rubocop:disable Metrics/MethodLength
        @candidate_count.times do |i|
          @candidate_count.times do |j|
            next if i == j

            @candidate_count.times do |k|
              next if i == k
              next if j == k

              @play_matrix[j, k] = [
                @play_matrix[j, k],
                [@play_matrix[j, i], @play_matrix[i, k]].min
              ].max
            end
          end
        end
      end

      def calculate_result
        @result_matrix.each_with_index do |e, x, y|
          next if x == y

          @result_matrix[x, y] = e + 1 if @play_matrix[x, y] > @play_matrix[y, x]
        end
      end

      def calculate_ranking
        @ranking = @result_matrix.row_vectors.map(&:sum)
      end

      def calculate_ranking_abc
        @ranking_abc =
          @ranking
          .map.with_index { |e, i| [e, @candidate_names[i]] }
          .sort
          .reverse
          .map do |(idx, name)|
            "#{name.length == 1 ? name.upcase : name}:#{@ranking.max - idx + 1}"
          end
      end
    end
  end
end
