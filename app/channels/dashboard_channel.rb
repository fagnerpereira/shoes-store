class DashboardChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'charts'
  end

  def unsubscribed; end
end
