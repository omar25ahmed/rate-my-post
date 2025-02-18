# Rate My Post 🚀

## Description

**Rate My Post** is a Ruby on Rails application that allows users to create, rate, and retrieve posts with ease. Designed to showcase API-driven functionality, it provides:

✅ A **REST API** for managing posts, users, and ratings.  
✅ Endpoints to retrieve **top-rated posts** and detect **IPs with multiple authors**.

## 🛠 Built With

![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=flat-square&logo=ruby-on-rails&logoColor=white)
![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=flat-square&logo=ruby&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=flat-square&logo=postgresql&logoColor=white)
![RSpec](https://img.shields.io/badge/RSpec-8E44AD?style=flat-square&logo=rubygems&logoColor=white)
![Rubocop](https://img.shields.io/badge/Rubocop-000000?style=flat-square&logo=codefactor&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat-square&logo=github-actions&logoColor=white)

## 🚀 Getting Started

### 1️⃣ Check Your Ruby & Rails Versions

Make sure you are using:

- **Ruby** `3.1.2` (or any compatible 3.x version)
- **Rails** `7.2.*` (or the latest 7.x release)

### 2️⃣ Clone the Repository

```bash
git clone git@github.com:omar25ahmed/rate-my-post.git
cd rate-my-post
```

### 3️⃣ Install Dependencies

```bash
bundle install
```

### 4️⃣ Set Up the Database

```bash
rails db:create db:migrate
```

### 5️⃣ Seed the Database

```bash
rails db:seed
```

_This will generate a large number of posts, users, and ratings using the API._

### 6️⃣ Start the Rails Server

```bash
rails server
```

Visit [`http://localhost:3000`](http://localhost:3000) in your browser or use Postman/cURL for API requests.

## 🎯 API Usage

### 🔹 Create a Post

**POST** `/api/v1/posts`

```json
{
  "title": "Your Title",
  "body": "Your Body",
  "user_login": "UserLogin",
  "user_ip": "127.0.0.1"
}
```

📌 **Response**: Returns the created post or validation errors.

### 🔹 Rate a Post

**POST** `/api/v1/posts/:id/ratings`

```json
{
  "user_id": 1,
  "value": 5
}
```

📌 **Response**: Returns the updated average rating.

### 🔹 Get Top N Posts by Rating

**GET** `/api/v1/posts/top?n=5`
📌 **Response**: Returns the top-rated posts sorted by average rating.

### 🔹 Detect Multiple Authors Using the Same IP

**GET** `/api/v1/posts/ips`
📌 **Response**: List of IPs used by multiple authors.

```json
[
  {
    "ip": "192.168.1.10",
    "authors": ["User1", "User2"]
  }
]
```

## ✅ Testing & CI/CD

### 🔹 Run Tests

This project uses **RSpec** for testing:

```bash
bundle exec rspec
```

### 🔹 Continuous Integration

GitHub Actions automatically runs tests and lint checks on **every commit** and **pull request**.

🚀 Happy coding! 🎉
