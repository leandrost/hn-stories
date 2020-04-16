class StoriesSearchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "search:#{params[:id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
