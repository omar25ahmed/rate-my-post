require 'rails_helper'

RSpec.describe Api::V1::RatingsController, type: :request do
  describe 'POST /api/v1/ratings' do
    let(:user) { create(:user) }
    let(:post_record) { create(:post) }
    let(:valid_params) { { user_id: user.id, value: 4 } }

    context 'when the request is valid' do
      it 'creates a rating and returns it' do
        post api_v1_post_ratings_path(post_record), params: valid_params

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)

        expect(json_response['value']).to eq(4)
        expect(json_response['post_id']).to eq(post_record.id)
        expect(json_response['user_id']).to eq(user.id)
      end
    end

    context 'when the user has already rated the post' do
      before do
        create(:rating, post: post_record, user: user, value: 3)
      end

      it 'returns a validation error' do
        post api_v1_post_ratings_path(post_record), params: valid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)

        expect(json_response).to include('Post has already been rated by this user')
      end
    end

    context 'when the rating value is invalid' do
      let(:invalid_params) { { post_id: post_record.id, user_id: user.id, value: 10 } }

      it 'returns a validation error' do
        post api_v1_post_ratings_path(post_record), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)

        expect(json_response).to include('Value must be less than or equal to 5')
      end
    end

    context 'when the post does not exist' do
      it 'returns a not found error' do
        post api_v1_post_ratings_path(post_id: 999_999), params: valid_params

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)

        expect(json_response['error']).to eq('Post or User not found')
      end
    end

    context 'when the user does not exist' do
      it 'returns a not found error' do
        post api_v1_post_ratings_path(post_record), params: { user_id: 999_999, value: 4 }

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)

        expect(json_response['error']).to eq('Post or User not found')
      end
    end
  end
end
