# Paginify

Paginify is a Ruby ​​library that implements offset pagination, where the advantage of this type of pagination is that it can flexibly get data on the desired page.

With the paginify library, your model can implement offset pagination. This is suitable for smaller data scales, as the deeper the offset, the slower the performance.

## High Flow

Offset pagination overview :

![Logo Ruby](https://github.com/solehudinmq/paginify/blob/development/high_flow/Paginify.jpg)

## Requirement

The minimum version of Ruby that must be installed is 3.0.

Requires dependencies to the following gems :
- activerecord

- activesupport

## Installation

Add this line to your application's Gemfile :

```ruby
# Gemfile
gem 'paginify', git: 'git@github.com:solehudinmq/paginify.git', branch: 'main'
```

Open terminal, and run this : 

```bash
cd your_ruby_application
bundle install
```

## Create Index

To improve pagination performance, add an index to the table that will use the pagination offset. For example in Postgresql :

```bash
CREATE INDEX index_your_table_on_created_at ON your_table (created_at);
```

For more details, you can see the following example : [example/post_index.txt](Here).

## Usage

In the model that will implement cursor pagination add this :

```ruby
require 'paginify'

class YourModel < ActiveRecord::Base
  include Paginify
end
```

For more details, you can see the following example : [example/post.rb](Here).

How to use offset pagination :

```ruby
result = YourModel.offset_paginate(page: params[:page], limit: params[:limit], order_by: params[:order_by])
```

Parameter description :
- page (optional) = is the page from which you want to retrieve data. Example : 1
- limit (optional) = is the amount of data you want to retrieve. Example : 10
- order_by (optional) = is to order the data in ascending/descending order. Example : 'asc' / 'desc'

For more details, you can see the following example : [example/app.rb](Here).

## Example Implementation in Your Application

For examples of applications that use this gem, you can see them here : [example](Here).

## Example of Offset Pagination Response

For examples of applications that use this gem, you can see them here : [response.json](Here).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/solehudinmq/paginify.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
