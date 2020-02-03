require 'rails_helper'

RSpec.shared_examples_for Commentable do
  it { should have_many(:comments).dependent(:destroy) }
end
