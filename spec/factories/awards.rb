FactoryBot.define do
  factory :award do
    title { 'cool guy' }
    image do
      fixture_file_upload(
        Rails.root.join('spec', 'fixtures', 'files', 'image.png'), 'image/png'
      )
    end
    question
  end
end
