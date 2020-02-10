FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '123123' }
    password_confirmation { '123123' }
    confirmed_at { Time.zone.now }

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
