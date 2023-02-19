module Webhooks
  class PurgeJob < ApplicationJob
    queue_as :default

    def perform(webhook_id)
      webhook = Webhook.find_by(id: webhook_id)
      webhook&.destroy
    end
  end
end
