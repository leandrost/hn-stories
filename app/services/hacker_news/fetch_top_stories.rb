# frozen_string_literal: true

module HackerNews
  class FetchTopStories
    STORIES_LIMIT = 15

    def self.client
      @client ||= HN::Client.new.tap do |client|
        client.configure do |config|
          config.api_url = 'https://hacker-news.firebaseio.com/v0/'
        end
      end
    end

    def client
      self.class.client
    end

    def self.call
      new.call
    end

    def call
      top_stories_ids = client.top_stories

      top_stories_ids.each do |id|
        story = client.item(id)
        next unless story.type == 'story'

        stories << story
        break if stories.length == STORIES_LIMIT
      end

      stories.sort_by(&:id).reverse!
    end

    private

    def stories
      @stories ||= []
    end
  end
end
