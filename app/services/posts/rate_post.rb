module Posts
  class RatePost
    def self.call(post_id:, user_id:, value:)
      new(post_id:, user_id:, value:).call
    end

    def initialize(post_id:, user_id:, value:)
      @post_id = post_id
      @user_id = user_id
      @value   = value.to_i
    end

    def call
      Rating.transaction do
        post = Post.find(post_id)
        user = User.find(user_id)

        rating = Rating.create!(post: post, user: user, value: value)

        rating_stat = RatingStat.find_or_create_by!(post_id: post_id)

        rating_stat.with_lock do
          rating_stat.ratings_sum   += value
          rating_stat.ratings_count += 1
          rating_stat.average_rating = rating_stat.ratings_sum.to_f / rating_stat.ratings_count
          rating_stat.save!
        end

        rating
      end
    end

    private

    attr_reader :post_id, :user_id, :value
  end
end
