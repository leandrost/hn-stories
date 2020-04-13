# frozen_string_literal: true

module HackerNews
  class FetchMostRelevantComments < ApplicationService
    include ApiClient

    WORDS_COUNT = 20

    def initialize(ids:)
      @ids = ids
    end

    def call
      ids.map do |id|
        comment = client.item(id)
        next if comment.deleted

        comment if relevant_comment?(comment)
      end.compact
    end

    private

    attr_reader :ids

    def relevant_comment?(comment)
      word_count = comment.text&.split&.length
      word_count >= WORDS_COUNT
    end
  end
end
