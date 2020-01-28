require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:link) { create(:link) }
  let(:gist) { create(:link, :gist) }

  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should allow_value('http://google.com').for(:url) }
  it { should_not allow_value('invalid format').for(:url) }

  describe '#gist?' do
    it 'returns false if a link is not a gist' do
      expect(link.gist?).to be false
    end

    it 'returns true if a link is a gist' do
      expect(gist.gist?).to be true
    end
  end
end