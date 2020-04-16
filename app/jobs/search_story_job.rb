# frozen_string_literal: true

class SearchStoryJob < ApplicationJob
  queue_as :default

  def perform(term:)
    HackerNews::SearchStories.call(term: term) do |story|
      ActionCable.server.broadcast(broadcasting, story.to_json)
    end
  end

  private

  def broadcasting
    @broadcasting ||= "search:#{job_id}"
  end
end
