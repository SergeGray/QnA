require 'rails_helper'

RSpec.describe SearchService do
  subject { SearchService }

  context 'with no resource selected' do
    it 'calls sphinx search method' do
      expect(ThinkingSphinx).to receive(:search).with('ruby')

      subject.new(query: 'ruby').call
    end
  end

  context 'with correct resource selected' do
    it 'calls sphinx search method on that resource' do
      expect(Question).to receive(:search).with('ruby')

      subject.new(query: 'ruby', resource: 'Question').call
    end
  end

  context 'with incorrect resource selected' do
    it 'calls sphinx search method' do
      expect(ThinkingSphinx).to receive(:search).with('ruby')

      subject.new(query: 'ruby', resource: 'Fake').call
    end
  end
end
