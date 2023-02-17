class Webhooks::PurgeJob < ApplicationJob
  queue_as :default

  def perform(webhook)
    webhook.destroy if webhook.persisted?
  end
end
