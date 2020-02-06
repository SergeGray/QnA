FactoryBot.define do
  factory :authorization do
    user
    provider { 'Github' }
    uid { '123456' }
  end
end
