# frozen_string_literal: true

class ListTopStories < ApplicationService
  def initialize(comment_for: nil)
    @comment_for = comment_for
  end

  def call
    stories = HackerNews::FetchTopStories.call
    stories.map do |story|
      load_comments(story)
      StoryPresenter.new(story)
    end
  end

  private

  attr_reader :comment_for

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
    return false if comment_for.blank?

    comment_for.try(:to_i) == story_id
  end
end
