class User < ApplicationRecord
  # Associations
  has_many :posts
  has_many :ratings

  # Validations
  validates :login, presence: true, uniqueness: true
end
