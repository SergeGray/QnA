FactoryBot.define do
  factory :question do
    title { "How do I output stuff to console in Ruby?" }
    body { "I am new please help!" }
    user

    trait :invalid do
      title { nil }
    end

    trait :new do
      title { "How do I convert Integer to String in Ruby?" }
      body { "I've tried literally everything!" }
      user
    end
  end
end
