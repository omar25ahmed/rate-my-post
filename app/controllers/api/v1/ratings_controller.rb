module Api
  module V1
    class RatingsController < ApplicationController
      def create
        rating = Posts::RatePost.call(rating_params.to_h.symbolize_keys)

        render json: rating, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: e.record.errors.full_messages, status: :unprocessable_entity
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Post or User not found' }, status: :not_found
      end

      private

      def rating_params
        params.permit(:post_id, :user_id, :value)
      end
    end
  end
end
