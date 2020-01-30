require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:gist) { build(:link, :gist) }
  let(:iframe) do
    content_tag(
      :iframe,
      '',
      src: "https://www.gonevis.com/toodartoo/embed/?media=#{gist.url}",
      class: "gist-link-#{gist.id}"
    )
  end

  describe '#embed_gist' do
    it 'returns an iframe with embedded gist' do
      expect(embed_gist(gist)).to eq(iframe)
    end
  end

  describe '#resource_name' do
    let(:question) { build(:question) }
    it 'returns resource class name as a downcased string' do
      expect(resource_name(question)).to eq('question')
    end
  end
end
