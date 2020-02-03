FactoryBot.define do
  factory :comment do
    user
    commentable { |factory| factory.association(:question) }
    body { "What kind of question is that?" }

    trait :invalid do
      body { nil }
    end
  end
end
