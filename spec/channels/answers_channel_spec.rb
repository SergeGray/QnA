require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  let(:question) { create(:question) }

  it 'subscribes to a stream when question_id is provided' do
    subscribe(question_id: question.id)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("questions/#{question.id}/answers")
  end
end
