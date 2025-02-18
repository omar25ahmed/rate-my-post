class Rating < ApplicationRecord
  # Associations
  belongs_to :post
  belongs_to :user

  # Validations
  validates :value, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :post_id, uniqueness: { scope: :user_id, message: 'has already been rated by this user' }
end
