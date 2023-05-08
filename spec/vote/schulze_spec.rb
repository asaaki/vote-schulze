# frozen_string_literal: true

RSpec.describe Vote::Schulze do
  it 'has a version number' do
    expect(Vote::Schulze::VERSION).not_to be_nil
  end

  # example calculation based on http://blog.cgiesel.de/schulze-methode/
  describe '.basic (with file example)' do
    let(:input_data) { File.open('examples/vote4.list') }
    let(:expected_result) { ['C:1', 'D:2', 'B:3', 'A:4'] }
    let(:voting) { described_class.basic(input_data) }

    it 'works with the example data' do
      expect(voting.ranking_abc).to eq(expected_result)
    end
  end
end
