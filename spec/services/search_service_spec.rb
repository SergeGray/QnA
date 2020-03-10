require 'rails_helper'

RSpec.describe SearchService do
  subject { SearchService }

  it 'calls sphinx search method' do
    expect(ThinkingSphinx).to receive(:search).with('ruby')

    subject.new(query: 'ruby').call
  end
end
