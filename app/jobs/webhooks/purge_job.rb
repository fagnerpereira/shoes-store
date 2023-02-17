class Webhooks::PurgeJob < ApplicationJob
  queue_as :default

  def perform(webhook)
    webhook.destroy!
  end
end
