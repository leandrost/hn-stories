# frozen_string_literal: true

module HackerNews
  class SearchStories < ApplicationService
    include ApiClient

    def initialize(term:)
      @term = term
    end

    def call
      fetch_args = { ids: stories_ids, type: 'story', limit: STORIES_LIMIT }

      FetchItems.call(fetch_args) do |story|
        next unless match_search?(story.title)

        yield(story) if block_given?
        stories << story
      end

      stories.sort_by(&:id).reverse!
    end

    private

    STORIES_LIMIT = 10
    SEARCH_SIZE = 1000

    attr_reader :term

    def stories
      @stories ||= []
    end

    def stories_ids
      client.get('newstories.json')
    end

    def match_search?(title)
      title.to_s.match?(/\b(#{term})\b/i)
    end
  end
end
