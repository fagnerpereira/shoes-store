class DashboardChannel < ApplicationCable::Channel
  def subscribed
    stream_for 'charts'
  end
  def unsubscribed
    puts 'unsubscribed'
  end
end
