class PriceChannel < ApplicationCable::Channel
  def subscribed
    stream_for params[:period]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
