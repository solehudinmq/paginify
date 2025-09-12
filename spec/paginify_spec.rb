# frozen_string_literal: true

RSpec.describe Paginify do
  before(:all) do
    # Delete old data and enter new data
    Post.destroy_all
    15.times do |i|
      Post.create(title: "Post #{15-i} Name", content:  "Post #{15-i} Content")
      sleep(0.1) # Add a gap to make the created_at different
    end

    @posts = Post.all
  end

  it "has a version number" do
    expect(Paginify::VERSION).not_to be nil
  end

  it "return the first 10 data without sending any parameters" do
    posts = Post.offset_paginate
    data = posts[:data]

    expect(data.length).to be 10

    expect(data[0].id).to be @posts[0].id
    expect(data[9].id).to be @posts[9].id

    expect(posts[:metadata][:page]).to be 1
    expect(posts[:metadata][:limit]).to be 10
    expect(posts[:metadata][:total_page]).to be 2
  end

  it "return 5 data and sorted asc by default" do
    # page 1
    posts = Post.offset_paginate(page: 1, limit: 5)
    data = posts[:data]

    expect(data.length).to be 5

    expect(data[0].id).to be @posts[0].id
    expect(data[4].id).to be @posts[4].id

    expect(posts[:metadata][:page]).to be 1
    expect(posts[:metadata][:limit]).to be 5
    expect(posts[:metadata][:total_page]).to be 3

    # page 2
    posts2 = Post.offset_paginate(page: 2, limit: 5)
    data2 = posts2[:data]

    expect(data2.length).to be 5

    expect(data2[0].id).to be @posts[5].id
    expect(data2[4].id).to be @posts[9].id

    expect(posts2[:metadata][:page]).to be 2
    expect(posts2[:metadata][:limit]).to be 5
    expect(posts2[:metadata][:total_page]).to be 3

    # page 3
    posts3 = Post.offset_paginate(page: 3, limit: 5)
    data3 = posts3[:data]

    expect(data3.length).to be 5
    
    expect(data3[0].id).to be @posts[10].id
    expect(data3[4].id).to be @posts[14].id

    expect(posts3[:metadata][:page]).to be 3
    expect(posts3[:metadata][:limit]).to be 5
    expect(posts3[:metadata][:total_page]).to be 3
  end

  it "return 5 data and sorted asc" do
    # page 1
    posts = Post.offset_paginate(page: 1, limit: 5, order_by: 'asc')
    data = posts[:data]

    expect(data.length).to be 5

    expect(data[0].id).to be @posts[0].id
    expect(data[4].id).to be @posts[4].id

    expect(posts[:metadata][:page]).to be 1
    expect(posts[:metadata][:limit]).to be 5
    expect(posts[:metadata][:total_page]).to be 3

    # page 2
    posts2 = Post.offset_paginate(page: 2, limit: 5)
    data2 = posts2[:data]

    expect(data2.length).to be 5

    expect(data2[0].id).to be @posts[5].id
    expect(data2[4].id).to be @posts[9].id

    expect(posts2[:metadata][:page]).to be 2
    expect(posts2[:metadata][:limit]).to be 5
    expect(posts2[:metadata][:total_page]).to be 3

    # page 3
    posts3 = Post.offset_paginate(page: 3, limit: 5)
    data3 = posts3[:data]

    expect(data3.length).to be 5
    
    expect(data3[0].id).to be @posts[10].id
    expect(data3[4].id).to be @posts[14].id

    expect(posts3[:metadata][:page]).to be 3
    expect(posts3[:metadata][:limit]).to be 5
    expect(posts3[:metadata][:total_page]).to be 3
  end

  it "return 5 data and sorted desc" do
    # page 1
    posts = Post.offset_paginate(page: 1, limit: 5, order_by: 'desc')
    data = posts[:data]

    expect(data.length).to be 5

    expect(data[0].id).to be @posts[14].id
    expect(data[4].id).to be @posts[10].id

    expect(posts[:metadata][:page]).to be 1
    expect(posts[:metadata][:limit]).to be 5
    expect(posts[:metadata][:total_page]).to be 3

    # page 2
    posts2 = Post.offset_paginate(page: 2, limit: 5, order_by: 'desc')
    data2 = posts2[:data]

    expect(data2.length).to be 5

    expect(data2[0].id).to be @posts[9].id
    expect(data2[4].id).to be @posts[5].id

    expect(posts2[:metadata][:page]).to be 2
    expect(posts2[:metadata][:limit]).to be 5
    expect(posts2[:metadata][:total_page]).to be 3

    # page 3
    posts3 = Post.offset_paginate(page: 3, limit: 5, order_by: 'desc')
    data3 = posts3[:data]

    expect(data3.length).to be 5
    
    expect(data3[0].id).to be @posts[4].id
    expect(data3[4].id).to be @posts[0].id

    expect(posts3[:metadata][:page]).to be 3
    expect(posts3[:metadata][:limit]).to be 5
    expect(posts3[:metadata][:total_page]).to be 3
  end

  it "return empty data" do
    posts = Post.offset_paginate(page: 10, limit: 5)
    data = posts[:data]

    expect(data.length).to be 0

    expect(posts[:metadata][:page]).to be 10
    expect(posts[:metadata][:limit]).to be 5
    expect(posts[:metadata][:total_page]).to be 3
  end
end
