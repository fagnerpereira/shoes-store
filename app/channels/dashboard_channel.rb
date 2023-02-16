class DashboardChannel < ApplicationCable::Channel
  def subscribed
    puts "subscribed #{params.inspect}"
    stream_for 'charts'
  end

  def received(data)
    puts "received #{data.inspect}"
  end

  def unsubscribed
    puts 'unsubscribed'
    # Any cleanup needed when channel is unsubscribed
  end
end
