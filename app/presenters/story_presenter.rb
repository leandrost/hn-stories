# frozen_string_literal: true

class StoryPresenter < SimpleDelegator
  include ActionView::Helpers::UrlHelper

  def most_relevant_comments
    object.most_relevant_comments || []
  end

  def comments_count
    count = object.kids&.size || 0
    I18n.t('presenters.story.comments', count: count)
  end

  def time
    I18n.l Time.at(object.time)
  end

  def comments_url
    url_helpers.stories_path(show_comments: id)
  end

  def to_hash
    super.merge(
      time: time,
      comments_url: comments_url,
      most_relevant_comments: most_relevant_comments,
      comments_count: comments_count
    )
  end

  def to_json(*args)
    to_hash.to_json(*args)
  end

  private

  def object
    __getobj__
  end

  def url_helpers
    Rails.application.routes.url_helpers
  end
end
