require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  it 'subscribes to a stream when question_id is provided' do
    subscribe

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('questions')
  end
end
