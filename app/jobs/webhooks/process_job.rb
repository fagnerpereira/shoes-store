module Webhooks
  class ProcessJob < ApplicationJob
    queue_as :default

    def perform
      Webhook.pending.order(created_at: :asc).each(&:process!)
    end
  end
end
