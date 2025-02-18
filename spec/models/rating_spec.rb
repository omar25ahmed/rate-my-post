require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe 'associations' do
    it 'belongs to post' do
      association = described_class.reflect_on_association(:post)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    let(:rating) { build(:rating) }

    it 'is valid with valid attributes' do
      expect(rating).to be_valid
    end

    it 'is invalid without a value' do
      rating.value = nil
      expect(rating).not_to be_valid
      expect(rating.errors[:value]).to include("can't be blank")
    end

    it 'is invalid when value is out of allowed range' do
      rating.value = 6
      expect(rating).not_to be_valid
      expect(rating.errors[:value]).to include('must be less than or equal to 5')

      rating.value = 0
      expect(rating).not_to be_valid
      expect(rating.errors[:value]).to include('must be greater than or equal to 1')
    end

    context 'uniqueness of (post_id, user_id)' do
      before do
        create(:rating, post: rating.post, user: rating.user)
        rating.assign_attributes(post: rating.post, user: rating.user)
      end

      it 'is invalid if the user has already rated the same post' do
        expect(rating).not_to be_valid
        expect(rating.errors[:post_id]).to include('has already been rated by this user')
      end
    end
  end
end
