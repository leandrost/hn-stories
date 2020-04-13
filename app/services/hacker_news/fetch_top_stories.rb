# frozen_string_literal: true

module HackerNews
  class FetchTopStories
    include ApiClient

    STORIES_LIMIT = 5

    def self.call
      new.call
    end

    def call
      top_stories_ids.each do |id|
        story = client.item(id)
        next unless story.type == 'story'

        stories << story
        break if stories.length == STORIES_LIMIT
      end

      stories.sort_by(&:id).reverse!
    end

    private

    def top_stories_ids
      @top_stories_ids ||= client.top_stories
    end

    def stories
      @stories ||= []
    end
  end
end
