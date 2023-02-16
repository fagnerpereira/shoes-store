require 'test_helper'

class DashboardChannelTest < ActionCable::Channel::TestCase
  test 'subscribes and stream for room' do
    subscribe

    assert subscription.confirmed?
    assert_has_stream 'dashboard:charts'
  end
end
