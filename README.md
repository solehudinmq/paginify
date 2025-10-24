# Paginify

Paginify is a Ruby ​​library that implements offset pagination, where the advantage of this type of pagination is that it can flexibly get data on the desired page.

With the paginify library, your model can implement offset pagination. This is suitable for smaller data scales, as the deeper the offset, the slower the performance.

## High Flow

Offset pagination overview :
![Logo Ruby](https://github.com/solehudinmq/paginify/blob/development/high_flow/Paginify.jpg)

## Installation

The minimum version of Ruby that must be installed is 3.0.
Only runs on activerecord.

Add this line to your application's Gemfile :

```ruby
gem 'paginify', git: 'git@github.com:solehudinmq/paginify.git', branch: 'main'
```

Open terminal, and run this : 
```bash
cd your_ruby_application
bundle install
```

To improve pagination performance, add an index to the table that will use the pagination offset. For example in Postgresql :
```bash
CREATE INDEX index_your_table_on_created_at ON your_table (created_at);
```

Example : 

```bash
CREATE INDEX index_posts_on_posts_created_at ON posts (created_at);
```

## Usage

In the model that will implement cursor pagination add this :
```ruby
require 'paginify'

class YourModel < ActiveRecord::Base
  include Paginify
end
```

How to use offset pagination :
```ruby
result = YourModel.offset_paginate(page: params[:page], limit: params[:limit], order_by: params[:order_by])
```

Parameter description :
- page (optional) = is the page from which you want to retrieve data. Example : 1
- limit (optional) = is the amount of data you want to retrieve. Example : 10
- order_by (optional) = is to order the data in ascending/descending order. Example : 'asc' / 'desc'

Example of usage in your application :
```ruby
# Gemfile
# frozen_string_literal: true

source "https://rubygems.org"

gem "byebug"
gem "sinatra"
gem "activerecord"
gem "sqlite3"
gem "rackup", "~> 2.2"
gem "puma", "~> 7.0"
gem 'paginify', git: 'git@github.com:solehudinmq/paginify.git', branch: 'main'
```

```ruby
# post.rb
require 'sinatra'
require 'active_record'
require 'byebug'
require 'paginify'

# Configure database connections
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/development.sqlite3'
)

# Create a db directory if it doesn't exist yet
Dir.mkdir('db') unless File.directory?('db')

# Model
class Post < ActiveRecord::Base
  include Paginify
end

# Migration to create posts table
ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.table_exists?(:posts)
    create_table :posts do |t|
      t.string :title
      t.string :content
      t.timestamps
    end
  end
end
```

```ruby
# app.rb
require 'sinatra'
require 'json'
require 'byebug'
require_relative 'post'

# Route to fetch posts data with offset pagination
get '/posts' do
  begin
    posts = Post.offset_paginate(page: params[:page], limit: params[:limit], order_by: params[:order_by])

    content_type :json
    posts.to_json
  rescue => e
    content_type :json
    status 500
    return { error: e.message }.to_json
  end
end

# Route to enter dummy data
post '/seed' do
  # Delete old data and enter new data
  Post.destroy_all
  15.times do |i|
    Post.create(title: "Post #{15-i} Name", content:  "Post #{15-i} Content")
    sleep(0.1) # Add a gap to make the created_at different
  end
  'Database seeded with 15 posts.'
end

# open terminal
# cd your_project
# bundle install
# bundle exec ruby app.rb
# curl --location --request POST 'http://localhost:4567/seed' // untuk create dummy data
# curl --location 'http://localhost:4567/posts?page=1&limit=5&order_by=asc' // untuk dapat halaman 1
```

Example of offset pagination response : 
```json
{
    "data": [
        {
            "id": 1,
            "title": "Post 15 Name",
            "content": "Post 15 Content",
            "created_at": "2025-09-12T02:04:29.034Z",
            "updated_at": "2025-09-12T02:04:29.034Z"
        },
        {
            "id": 2,
            "title": "Post 14 Name",
            "content": "Post 14 Content",
            "created_at": "2025-09-12T02:04:29.144Z",
            "updated_at": "2025-09-12T02:04:29.144Z"
        },
        {
            "id": 3,
            "title": "Post 13 Name",
            "content": "Post 13 Content",
            "created_at": "2025-09-12T02:04:29.246Z",
            "updated_at": "2025-09-12T02:04:29.246Z"
        },
        {
            "id": 4,
            "title": "Post 12 Name",
            "content": "Post 12 Content",
            "created_at": "2025-09-12T02:04:29.347Z",
            "updated_at": "2025-09-12T02:04:29.347Z"
        },
        {
            "id": 5,
            "title": "Post 11 Name",
            "content": "Post 11 Content",
            "created_at": "2025-09-12T02:04:29.447Z",
            "updated_at": "2025-09-12T02:04:29.447Z"
        }
    ],
    "metadata": {
        "page": 1,
        "limit": 5,
        "total_page": 3
    }
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/solehudinmq/paginify.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
