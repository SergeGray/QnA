FactoryBot.define do
  factory :link do
    name { 'Google' }
    url { 'http://google.com' }
    linkable { |factory| factory.association(:question) }

    trait :yandex do
      name { 'Yandex' }
      url { 'http://yandex.ru' }
    end

    trait :gist do
      name { 'Gist' }
      url do
        'https://gist.github.com/SergeGray/'\
        '1587bc05c44bbe74cff4a7f12f2c43a9'
      end
    end
  end
end
