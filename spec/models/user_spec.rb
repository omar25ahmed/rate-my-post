require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is invalid without a login' do
      user = build(:user, login: nil)
      expect(user).not_to be_valid
      expect(user.errors[:login]).to include("can't be blank")
    end

    it 'is invalid with a duplicate login' do
      create(:user, login: 'duplicate_login')
      user = build(:user, login: 'duplicate_login')
      expect(user).not_to be_valid
      expect(user.errors[:login]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it 'has many posts' do
      association = described_class.reflect_on_association(:posts)
      expect(association.macro).to eq :has_many
    end

    it 'has many ratings' do
      association = described_class.reflect_on_association(:ratings)
      expect(association.macro).to eq :has_many
    end
  end
end
