# frozen_string_literal: true

class ListTopStories < ApplicationService
  def initialize(show_comments:)
    @show_comments = show_comments
  end

  def call
    stories = HackerNews::FetchTopStories.call
    stories.map do |story|
      load_comments(story)
      StoryPresenter.new(story)
    end
  end

  private

  attr_reader :show_comments

  def load_comments(story)
    return unless show_comments?(story.id)

    story.most_relevant_comments = most_relevant_comment_for(story)
  end

  def most_relevant_comment_for(story)
    HackerNews::FetchMostRelevantComments.call(
      ids: story.kids
    )
  end

  def show_comments?(story_id)
    show_comments.try(:to_i) == story_id
  end
end
