# frozen_string_literal: true

class StoriesController < ApplicationController
  def index
    @stories = HackerNews::FetchTopStories.call
  end

  attr_reader :stories
end
