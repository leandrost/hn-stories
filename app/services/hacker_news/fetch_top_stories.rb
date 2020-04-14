# frozen_string_literal: true

module HackerNews
  class FetchTopStories < ApplicationService
    include ApiClient

    def call
      top_stories_ids.each do |id|
        story = client.item(id)
        next unless story.type == 'story'

        stories << story
        break if stories.size == STORIES_LIMIT
      end

      stories.sort_by(&:id).reverse!
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
