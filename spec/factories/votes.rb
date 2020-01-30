FactoryBot.define do
  factory :vote do
    user
    votable { |factory| factory.association(:question) }
    positive { true }

    trait :negative do
      positive { false }
    end
  end
end
