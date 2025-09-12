# frozen_string_literal: true

require_relative "paginify/version"
require_relative 'paginify/strategies/order_by_validator'
require 'active_support/concern'

module Paginify extend ActiveSupport::Concern
  class Error < StandardError; end
  # Your code goes here...

  class_methods do
    def offset_paginate(page: nil, limit: nil, order_by: nil)
      page ||= 1
      limit ||= 10
      order_by ||= 'asc'
      puts "page : #{page}, limit : #{limit}, order_by: #{order_by}"

      page = page.to_i
      limit = limit.to_i

      # Validation for order_by parameter value
      OrderByValidator.validate(order_by)

      # get offset position
      offset = (page - 1) * limit
      # get data based on offset position
      data = self.limit(limit).offset(offset).order(created_at: order_by)

      { data: data, metadata: { page: page, limit: limit } }
    end
  end
end
