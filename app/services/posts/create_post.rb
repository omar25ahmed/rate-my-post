module Posts
  class CreatePost
    def self.call(title: nil, body: nil, user_ip: nil, user_login: nil)
      new(title, body, user_ip, user_login).call
    end

    def initialize(title, body, user_ip, user_login)
      @title = title
      @body = body
      @user_ip = user_ip
      @user_login = user_login
    end

    def call
      user = User.find_or_create_by(login: user_login)
      user.posts.create(title: title, body: body, ip: user_ip)
    end

    private

    attr_reader :title, :body, :user_ip, :user_login
  end
end
