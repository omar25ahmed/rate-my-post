FactoryBot.define do
  factory :user do
    sequence(:login) { Faker::Internet.unique.username(specifier: 8) }
  end
end
