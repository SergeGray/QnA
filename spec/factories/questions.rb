FactoryBot.define do
  factory :question do
    title { "How do I output stuff to console in Ruby?" }
    body { "I am new please help!" }

    trait :invalid do
      title { nil }
    end
  end
end
