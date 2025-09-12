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
      
      page = page.to_i
      limit = limit.to_i

      # Validation for order_by parameter value
      OrderByValidator.validate(order_by)

      data = self.order(created_at: order_by)
      total_page = (data.count.to_f / limit).ceil

      # get offset position
      offset = (page - 1) * limit

      # get data based on offset position
      data = data.limit(limit).offset(offset)

      { data: data, metadata: { page: page, limit: limit, total_page: total_page } }
    end
  end
end
