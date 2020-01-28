require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:gist) { create(:link, :gist) }
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
end