FactoryBot.define do
  factory :rating_stat do
    association :post

    ratings_sum { 0 }
    ratings_count { 0 }
    average_rating { 0.0 }

    factory :rating_stat_custom do
      ratings_sum { 10 }
      ratings_count { 5 }
      average_rating { 2.0 }
    end
  end
end
