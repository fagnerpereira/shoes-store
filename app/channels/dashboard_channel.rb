class DashboardChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'charts'
  end

  def unsubscribed
    puts 'unsubscribed'
  end
end
