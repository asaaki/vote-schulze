# frozen_string_literal: true

RSpec.describe Vote::Schulze::Basic do
  # example calculation based on http://blog.cgiesel.de/schulze-methode/
  context 'when input is a file' do
    let(:input_data) { File.open('examples/vote4.list') }
    let(:expected_result) { ['C:1', 'D:2', 'B:3', 'A:4'] }
    let(:voting) { described_class.call(input_data) }

    it 'works with the example data' do
      expect(voting.ranking_abc).to eq(expected_result)
    end
  end
end
