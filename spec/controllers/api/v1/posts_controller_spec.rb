require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :request do
  describe 'POST /api/v1/posts' do
    let(:user_login) { 'test_user' }
    let(:valid_params) do
      { post: { title: 'My Post', body: 'Post body', user_login: user_login }, user_ip: '192.168.1.1' }
    end

    context 'when request is valid' do
      it 'creates a post and returns it' do
        post api_v1_posts_path, params: valid_params

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)

        expect(json_response['title']).to eq('My Post')
        expect(json_response['body']).to eq('Post body')
      end
    end

    context 'when request is invalid' do
      let(:invalid_params) { { post: { title: '', body: '', user_login: user_login } } }

      it 'returns validation errors' do
        post api_v1_posts_path, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)

        expect(json_response).to include("Title can't be blank", "Body can't be blank")
      end
    end
  end

  describe 'GET /api/v1/posts/top' do
    let!(:post1) { create(:post) }
    let!(:post2) { create(:post) }
    let!(:post3) { create(:post) }

    before do
      create(:rating_stat, post: post1, average_rating: 4.5)
      create(:rating_stat, post: post2, average_rating: 3.0)
      create(:rating_stat, post: post3, average_rating: 5.0)
    end

    it 'returns the top N posts ordered by average rating' do
      get top_api_v1_posts_path(n: 2)

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response.size).to eq(2)
      expect(json_response.first['id']).to eq(post3.id) # Highest rating first
      expect(json_response.second['id']).to eq(post1.id) # Second highest rating
    end
  end

  describe 'GET /api/v1/posts/ips' do
    let!(:user1) { create(:user, login: 'User1') }
    let!(:user2) { create(:user, login: 'User2') }

    before do
      create(:post, user: user1, ip: '1.1.1.1')
      create(:post, user: user2, ip: '1.1.1.1')
      create(:post, user: user1, ip: '2.2.2.2') # This IP has only one author
    end

    it 'returns IPs with multiple authors' do
      get ips_api_v1_posts_path

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response).to contain_exactly(
        { 'ip' => '1.1.1.1', 'logins' => match_array(['User1', 'User2']) }
      )
    end
  end
end
