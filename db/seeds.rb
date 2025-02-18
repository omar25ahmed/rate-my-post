# =========================
# Configuration
# =========================

NUM_USERS        = 100
NUM_POSTS        = 200_000
NUM_IP_ADDRESSES = 50
RATING_PERCENT   = 0.75 # 75% of posts will be rated

API_HOST             = 'http://localhost:3000'
CREATE_POST_ENDPOINT = '/api/v1/posts' # posts endpoint
RATE_POST_ENDPOINT   = ->(post_id) { "/api/v1/posts/#{post_id}/ratings" } # ratings endpoint

BATCH_SIZE           = 1000

# =========================
# Setup Faraday Client
# =========================

client = Faraday.new(url: API_HOST)

# =========================
# Generate Data
# =========================

puts "=== Generating unique user logins ==="
user_logins = Array.new(NUM_USERS) { Faker::Internet.unique.username(specifier: 8) }

puts "=== Generating unique IP addresses ==="
ips = Array.new(NUM_IP_ADDRESSES) { Faker::Internet.unique.ip_v4_address }

# =========================
# Helper Methods
# =========================

def create_post(client, title:, body:, user_login:, user_ip:)
  response = client.post do |req|
    req.url CREATE_POST_ENDPOINT
    req.headers['Content-Type'] = 'application/json'
    req.body = {
      post: {
        title:      title,
        body:       body,
        user_login: user_login,
        user_ip:    user_ip
      }
    }.to_json
  end

  if response.success?
    JSON.parse(response.body)
  else
    puts "Create Post ERROR: #{response.status} - #{response.body}"
    nil
  end
end

def rate_post(client, post_id:, user_id:, value:)
  response = client.post do |req|
    req.url RATE_POST_ENDPOINT.call(post_id)
    req.headers['Content-Type'] = 'application/json'
    req.body = {
      user_id: user_id,
      value:   value
    }.to_json
  end

  if response.success?
    JSON.parse(response.body)
  else
    puts "Rate Post ERROR: #{response.status} - #{response.body}"
    nil
  end
end

# =========================
# Main Seeds Loop
# =========================

puts "=== Creating Posts & Ratings ==="
post_count = 0

while post_count < NUM_POSTS
  batch_limit = [ BATCH_SIZE, NUM_POSTS - post_count ].min
  posts_in_this_batch = []

  batch_limit.times do
    title = Faker::Lorem.sentence(word_count: 3)
    body  = Faker::Lorem.paragraph(sentence_count: 2)

    user_login = user_logins.sample
    ip         = ips.sample

    created_post = create_post(
      client,
      title:      title,
      body:       body,
      user_login: user_login,
      user_ip:    ip
    )

    posts_in_this_batch << created_post if created_post
  end

  # Rate ~75% of these posts
  posts_in_this_batch.each do |post_data|
    next unless post_data
    next if rand >= RATING_PERCENT  # skip rating for ~25%

    post_id = post_data["id"]
    user_id = post_data.dig("user", "id")

    rating_value = rand(1..5)
    rate_post(client, post_id: post_id, user_id: user_id, value: rating_value)
  end

  post_count += batch_limit
  puts "Created & (possibly) rated #{post_count} posts so far..."
end

puts "=== Done! ==="
