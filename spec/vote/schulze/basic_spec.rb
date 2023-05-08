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

  it 'exposes votes' do
    input_data = "D;B;A;C\nD;A;B;C"
    voting = described_class.call(input_data, 4)
    expect(voting.votes).to eq([[2, 3, 1, 4], [3, 2, 1, 4]])
  end

  context 'when input is with names' do
    let(:input_data) { File.open('examples/vote4names.list') }
    let(:expected_result) { ['charlie:1', 'delta:2', 'bravo:3', 'alpha:4'] }
    let(:voting) { described_class.call(input_data) }

    it 'produces ranks by name' do
      expect(voting.ranking_abc).to eq(expected_result)
    end
  end
end
