module Api
  module V1
    class RatingsController < ApplicationController
      def create
        rating = Posts::RatePost.call(
          post_id: params[:post_id],
          user_id: params[:user_id],
          value: params[:value]
        )

        render json: rating, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: e.record.errors.full_messages, status: :unprocessable_entity
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Post or User not found" }, status: :not_found
      end
    end
  end
end
