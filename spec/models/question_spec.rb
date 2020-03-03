require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { create(:user) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it do
    should have_many(:subscribed_users)
      .through(:subscriptions)
      .source(:user)
  end
  it { should have_one(:award).dependent(:destroy) }
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :award }

  it_behaves_like Commentable
  it_behaves_like Linkable
  it_behaves_like Votable do
    let(:resource) { create(:question) }
  end

  it 'has many attached files' do
    expect(Question.new.files)
      .to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it 'subscribes author on creation' do
    expect { create(:question, user: user) }
      .to change(user.subscriptions, :count).by 1
  end
end
