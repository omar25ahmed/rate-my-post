require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    let(:post) { build(:post) }

    it 'is valid with valid attributes' do
      expect(post).to be_valid
    end

    it 'is invalid without a title' do
      post.title = nil
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without a body' do
      post.body = nil
      expect(post).not_to be_valid
      expect(post.errors[:body]).to include("can't be blank")
    end

    it 'is invalid without an ip' do
      post.ip = nil
      expect(post).not_to be_valid
      expect(post.errors[:ip]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many ratings' do
      association = described_class.reflect_on_association(:ratings)
      expect(association.macro).to eq :has_many
    end

    it 'has one rating_stat' do
      association = described_class.reflect_on_association(:rating_stat)
      expect(association.macro).to eq :has_one
    end
  end

  describe '.top_by_average_rating' do
    let!(:post1) { create(:post) }
    let!(:post2) { create(:post) }
    let!(:post3) { create(:post) }

    before do
      create(:rating_stat, post: post1, average_rating: 4.5)
      create(:rating_stat, post: post2, average_rating: 2.0)
      create(:rating_stat, post: post3, average_rating: 3.0)
    end

    it 'returns the top n posts by average rating in descending order' do
      result = described_class.top_by_average_rating(2)

      expect(result).to eq([post1, post3])
    end
  end
end
