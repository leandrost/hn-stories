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
        next if comment.deleted || comment.dead

        comment if relevant_comment?(comment)
      end.compact
    end

    private

    attr_reader :ids

    def relevant_comment?(comment)
      text = ActionView::Base.full_sanitizer.sanitize(comment.text)
      word_count = text&.split&.size
      word_count >= WORDS_COUNT
    end
  end
end
