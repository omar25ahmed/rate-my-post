FactoryBot.define do
  factory :rating do
    value { rand(1..5) }

    association :post
    association :user
  end
end
