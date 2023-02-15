class DashboardChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'charts'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
