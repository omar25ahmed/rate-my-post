require 'rails_helper'

RSpec.describe RatingStat, type: :model do
  describe 'associations' do
    it 'belongs to post' do
      association = described_class.reflect_on_association(:post)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    let(:rating_stat) { build(:rating_stat) }

    it 'is valid with a post' do
      expect(rating_stat).to be_valid
    end

    it 'is invalid without a post' do
      rating_stat.post = nil
      expect(rating_stat).not_to be_valid
      expect(rating_stat.errors[:post]).to include('must exist')
    end
  end
end
