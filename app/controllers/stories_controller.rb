# frozen_string_literal: true

class StoriesController < ApplicationController
  def index
    if searching?
      search_stories
    else
      list_top_stories
    end
  end

  private

  def searching?
    query_params[:q].present?
  end

  def list_top_stories
    @stories = ListTopStories.call(
      comment_for: query_params[:show_comments]
    )
  end

  def search_stories
    SearchStoryJob.perform_later(term: query_params[:q]).tap do |search_job|
      @search_id = search_job.job_id
      @stories = []
    end
  end

  def query_params
    params.permit(:show_comments, :q)
  end
end
