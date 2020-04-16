# frozen_string_literal: true

class SearchStoryJob < ApplicationJob
  queue_as :default

  def perform(term:)
    HackerNews::SearchStories.call(term: term) do |story|
      json = StoryPresenter.new(story).to_json
      ActionCable.server.broadcast(broadcasting, json)
    end
  end

  private

  def broadcasting
    @broadcasting ||= "search:#{job_id}"
  end
end
