require 'rails_helper'

RSpec.describe Posts::RatePost, type: :service do
  describe '.call' do
    let(:user) { create(:user) }
    let(:post_record) { create(:post) }
    let(:valid_value) { 4 }

    subject(:rate_post) do
      described_class.call(
        post_id: post_record.id,
        user_id: user.id,
        value: valid_value
      )
    end

    context 'with valid parameters' do
      it 'creates a new Rating and RatingStat when they do not exist' do
        expect { rate_post }
          .to change(Rating, :count).by(1)
          .and change(RatingStat, :count).by(1)

        rating = Rating.last
        stat = RatingStat.last

        expect(rating.value).to eq(valid_value)
        expect(rating.user).to eq(user)
        expect(rating.post).to eq(post_record)

        expect(stat.post).to eq(post_record)
        expect(stat.ratings_sum).to eq(valid_value)
        expect(stat.ratings_count).to eq(1)
        expect(stat.average_rating).to eq(valid_value.to_f)
      end

      it 'updates an existing RatingStat if present' do
        existing_stat = create(:rating_stat, post: post_record,
                                             ratings_sum: 5,
                                             ratings_count: 2,
                                             average_rating: 2.5)

        expect { rate_post }
          .to change(Rating, :count).by(1)
          .and change(RatingStat, :count).by(0)

        existing_stat.reload

        expect(existing_stat.ratings_sum).to eq(9)
        expect(existing_stat.ratings_count).to eq(3)
        expect(existing_stat.average_rating).to eq(3.0)
      end

      it 'returns the newly created Rating' do
        result = rate_post
        expect(result).to be_a(Rating)
        expect(result.value).to eq(valid_value)
        expect(result.post).to eq(post_record)
        expect(result.user).to eq(user)
      end
    end

    context 'when the user has already rated the post' do
      before do
        create(:rating, post: post_record, user: user, value: 3)
      end

      it 'raises a validation error due to uniqueness constraint' do
        expect { rate_post }.to raise_error(ActiveRecord::RecordInvalid) do |error|
          expect(error.record.errors[:post_id]).to include('has already been rated by this user')
        end
      end
    end

    context 'when the rating value is invalid' do
      subject(:rate_invalid_post) do
        described_class.call(post_id: post_record.id, user_id: user.id, value: 10)
      end

      it 'raises a validation error (check constraint 1..5)' do
        expect { rate_invalid_post }.to raise_error(ActiveRecord::RecordInvalid) do |error|
          expect(error.record.errors[:value]).to include('must be less than or equal to 5')
        end
      end
    end

    context 'when the post does not exist' do
      subject(:rate_nonexistent_post) do
        described_class.call(post_id: 999_999, user_id: user.id, value: valid_value)
      end

      it 'raises an ActiveRecord::RecordNotFound error' do
        expect { rate_nonexistent_post }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the user does not exist' do
      subject(:rate_post_with_invalid_user) do
        described_class.call(post_id: post_record.id, user_id: 999_999, value: valid_value)
      end

      it 'raises an ActiveRecord::RecordNotFound error' do
        expect { rate_post_with_invalid_user }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
