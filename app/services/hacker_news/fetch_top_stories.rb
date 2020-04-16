# frozen_string_literal: true

module HackerNews
  class FetchTopStories < ApplicationService
    include ApiClient

    def call
      FetchItems.call(
        ids: top_stories_ids,
        type: 'story',
        limit: STORIES_LIMIT
      ).sort_by(&:id).reverse!
    end

    private

    STORIES_LIMIT = 15

    def top_stories_ids
      @top_stories_ids ||= client.top_stories
    end

    def stories
      @stories ||= []
    end
  end
end
