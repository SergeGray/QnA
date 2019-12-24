FactoryBot.define do
  factory :answer do
    body { "Use puts method." }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :new do
      body { "You can use either puts, print, or p depending on your needs." }
    end
  end
end
