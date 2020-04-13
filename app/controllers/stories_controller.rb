# frozen_string_literal: true

class StoriesController < ApplicationController
  def index
    @stories = HackerNews::FetchTopStories.call

    @stories.each do |story|
      story.comments = []
      next unless show_comments?(story.id)

      comments = HackerNews::FetchMostRelevantComments.call(
        ids: story.kids
      )

      next if comments.blank?

      story.comments = comments
    end
  end

  private

  attr_reader :stories

  def show_comments?(story_id)
    query_params[:show_comments].try(:to_i) == story_id
  end

  def query_params
    params.permit(:show_comments)
  end
end
