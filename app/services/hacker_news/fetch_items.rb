# frozen_string_literal: true

module HackerNews
  class FetchItems < ApplicationService
    include ApiClient

    def initialize(ids:, type:, limit: 10)
      @ids = ids
      @type = type
      @limit = limit
    end

    def call
      ids.each do |id|
        Rails.logger.info("item ##{id}")
        item = client.item(id)
        Rails.logger.info(item)

        break if item.blank?
        next if invalid_item?(item)

        item = yield(item) if block_given?

        add_item(item)

        break if reach_items_limit?
      end

      items
    end

    private

    attr_reader :ids, :type, :limit

    def items
      @items ||= []
    end

    def reach_items_limit?
      items.size == limit
    end

    def invalid_item?(item)
      item.type != type || item.deleted || item.dead
    end

    def add_item(item)
      return if item.blank?

      items << item
    end
  end
end
