class Webhooks::ProcessJob < ApplicationJob
  queue_as :default

  def perform(webhook)
    puts 'starting to process webhook'
  end
end
