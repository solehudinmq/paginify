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