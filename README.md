# Paginify

Paginify is a Ruby ​​library that implements offset pagination, where the advantage of this type of pagination is that it can flexibly get data on the desired page.

With the paginify library, your model can implement offset pagination. This is suitable for smaller data scales, as the deeper the offset, the slower the performance.

## High Flow

Offset pagination overview: :
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

To improve pagination performance, add an index to the table that will use the pagination offset. For example :
```bash
CREATE INDEX index_posts_on_posts_created_at ON posts (created_at);
```

## Usage

In the model that will implement cursor pagination add this :
```ruby
require 'paginify'

class Post < ActiveRecord::Base
  include Paginify
end
```

How to use offset pagination :
```ruby
posts = Post.offset_paginate(page: params[:page], limit: params[:limit], order_by: params[:order_by])
```

Parameter description :
- page (optional) = is the page from which you want to retrieve data. Example : 1
- limit (optional) = is the amount of data you want to retrieve. Example : 10
- order_by (optional) = is to order the data in ascending/descending order. Example : 'asc' / 'desc'

Example of usage in your application :
```ruby
require 'sinatra'
require 'json'
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


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/solehudinmq/paginify.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
