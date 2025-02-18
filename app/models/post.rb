class Post < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :ratings
  has_one :rating_stat

  # Validations
  validates :title, :body, :ip, presence: true

  # Scopes
  scope :top_by_average_rating, ->(n = 10) {
    joins(:rating_stat)
      .order('rating_stats.average_rating DESC')
      .limit(n)
  }
end
