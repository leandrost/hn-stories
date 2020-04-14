# frozen_string_literal: true

module HackerNews
  class SearchStories < ApplicationService
    include ApiClient

    def initialize(term:)
      @term = term
    end

    def call
      stories_ids.each do |id|
        story = fetch_story(id)
        stories << story if match_search?(story&.title)
        break if stories.size == STORIES_LIMIT
      end

      stories
    end

    private

    STORIES_LIMIT = 10
    STORIES_PER_PAGE = 1000

    attr_reader :term

    def stories
      @stories ||= []
    end

    def fetch_story(id)
      item = client.item(id)
      return if item.blank? || item.type != 'story' || item.deleted || item.dead

      item
    end

    def stories_ids
      (start_id..max_id).to_a.reverse
    end

    def start_id
      return 1 if max_id < STORIES_PER_PAGE

      max_id - STORIES_PER_PAGE
    end

    def max_id
      client.max_item
    end

    def match_search?(title)
      title.to_s.match?(/\b(#{term})\b/i)
    end
  end
end
