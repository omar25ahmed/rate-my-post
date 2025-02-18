require 'rails_helper'

RSpec.describe Posts::CreatePost, type: :service do
  describe '.call' do
    let(:title)      { 'My Title' }
    let(:body)       { 'My Body' }
    let(:user_ip)    { '127.0.0.1' }
    let(:user_login) { 'test_login' }

    subject(:create_post_service) do
      described_class.call(
        title: title,
        body: body,
        user_ip: user_ip,
        user_login: user_login
      )
    end

    context 'when the user does not exist' do
      it 'creates a new user and a new post' do
        expect { create_post_service }
          .to change(User, :count).by(1)
          .and change(Post, :count).by(1)

        created_post = Post.last
        created_user = User.last

        expect(created_user.login).to eq(user_login)
        expect(created_post.title).to eq(title)
        expect(created_post.body).to eq(body)
        expect(created_post.ip).to eq(user_ip)
        expect(created_post.user).to eq(created_user)
      end
    end

    context 'when the user already exists' do
      let!(:existing_user) { create(:user, login: user_login) }

      it 'does not create a new user but does create a new post' do
        expect { create_post_service }
          .to change(Post, :count).by(1)
          .and change(User, :count).by(0)

        created_post = Post.last
        expect(created_post.user).to eq(existing_user)
        expect(created_post.title).to eq(title)
        expect(created_post.body).to eq(body)
        expect(created_post.ip).to eq(user_ip)
      end
    end
  end
end
