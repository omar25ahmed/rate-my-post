module Api
  module V1
    class PostsController < ApplicationController
      def create
        post = Posts::CreatePost.call(**post_params.to_h.symbolize_keys, user_ip: params[:user_ip] || request.remote_ip)

        if post.persisted?
          render json: post, serializer: PostSerializer, status: :created
        else
          render json: post.errors.full_messages, status: :unprocessable_entity
        end
      end

      def top
        n = params[:n].to_i
        posts = Post.top_by_average_rating(n)
        render json: posts, each_serializer: MinimalPostSerializer, status: :ok
      end

      def ips
        ips = Posts::FetchIpsMultipleAuthors.call
        render json: ips, status: :ok
      end

      private

      def post_params
        params.require(:post).permit(:title, :body, :user_login)
      end
    end
  end
end
