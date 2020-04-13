# frozen_string_literal: true

module HackerNews
  module ApiClient
    extend ActiveSupport::Concern

    class_methods do
      def client
        @client ||= HN::Client.new.tap do |client|
          client.configure do |config|
            config.api_url = 'https://hacker-news.firebaseio.com/v0/'
          end
        end
      end
    end

    def client
      self.class.client
    end
  end
end
