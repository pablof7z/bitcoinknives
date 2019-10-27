class TradesChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user.id
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
