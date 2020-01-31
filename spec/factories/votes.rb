FactoryBot.define do
  factory :vote do
    user
    votable { |factory| factory.association(:question) }
    value { 1 }

    trait :negative do
      value { -1 }
    end
  end
end
