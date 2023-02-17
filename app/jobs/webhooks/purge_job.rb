class Webhooks::PurgeJob < ApplicationJob
  queue_as :default

  def perform(webhook)
    return
    webhook.destroy
  end
end
