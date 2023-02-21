module Webhooks
  class PurgeJob < ApplicationJob
    queue_as :default
    discard_on ActiveJob::DeserializationError

    def perform(webhook_id)
      webhook = Webhook.find_by(id: webhook_id)
      webhook&.destroy
    end
  end
end
