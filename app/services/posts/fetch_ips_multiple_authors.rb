module Posts
  class FetchIpsMultipleAuthors
    def self.call
      rows = Post
        .joins(:user)
        .group(:ip)
        .having(Arel.sql('COUNT(DISTINCT user_id) > 1'))
        .pluck(
          :ip,
          Arel.sql('ARRAY_AGG(DISTINCT users.login) AS logins')
        )

      rows.map { |ip, logins| { ip: ip, logins: logins } }
    end
  end
end
